//
//  FetchMonsterName.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2026/9/22.
//

import ArgumentParser
import Foundation

/// Scrapes monster names for one server from divine-pride.net and writes them
/// as `<input>/<client>/mobname.txt` (`id,name` per line) that
/// `MonsterNameConverter` can read, next to the rest of that client's data.
///
/// divine-pride keeps the selected server in a cookie set by
/// `POST /account/set-preference`, so the command sets it first and then walks
/// the paginated monster list with the same cookie storage.
///
/// The list leaves out clones that share a name with another monster (1220
/// "Desert Wolf" next to 1106), so afterwards the gaps are filled from
/// rAthena's `mob_db.yml`: a monster with no translation borrows the one of
/// another monster with the same English name.
struct FetchMonsterName: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "fetch-mobname",
        abstract: "Fetch a mobname.txt for one server from divine-pride.net."
    )

    /// A divine-pride server. `directory` is the client under `Input/` that
    /// server's names belong to, or `nil` while no such client is converted.
    enum Region: String, CaseIterable, ExpressibleByArgument {
        case bRO
        case cRO
        case dpRO
        case idRO
        case GGHRO
        case GZero
        case iRO
        case jRO
        case kROM
        case kROZ
        case LATAM
        case ropEU
        case ropRU
        case thROC
        case thROG
        case twRO
        case twROZero = "twRO zero"

        var directory: String? {
            switch self {
            case .bRO: "Brazil"
            case .cRO: "China"
            case .dpRO: nil
            case .idRO: "Indonesia"
            case .GGHRO: nil
            case .GZero: nil
            case .iRO: "International"
            case .jRO: "Japan"
            case .kROM: "Korea"
            case .kROZ: nil
            case .LATAM: "LatinAmerica"
            case .ropEU: "Europe"
            case .ropRU: "Russia"
            case .thROC: nil
            case .thROG: "Thailand"
            case .twRO: "Taiwan"
            case .twROZero: nil
            }
        }
    }

    @Option(help: "Server as named in the divine-pride server selector: \(Region.allCases.map(\.rawValue).joined(separator: ", ")).")
    var region: Region

    @Argument(help: "Directory containing one subdirectory per client; the file is written to <input>/<client>/mobname.txt.", transform: { URL(fileURLWithPath: $0, isDirectory: true) })
    var input: URL

    private static let baseURL = URL(string: "https://www.divine-pride.net")!

    func run() async throws {
        guard let directory = region.directory else {
            throw ValidationError("No client directory is mapped for \(region.rawValue) yet.")
        }
        let output = input.appendingPathIgnoringCase(directory).appendingPathComponent("mobname.txt")
        let session = URLSession(configuration: .ephemeral)

        // Fetch the English names first.
        let englishNames = try await fetchEnglishNames(with: session)
        print("Fetched \(englishNames.count) English monster names from mob_db.yml")

        try await setPreference(["region": region.rawValue], with: session)

        var monsterNames: [Int : String] = [:]
        var page = 1
        while true {
            let html = try await fetchMonsterListPage(page, with: session)
            guard let (current, total) = pageIndex(in: html) else {
                throw ValidationError("Could not find pagination on page \(page); the page layout may have changed.")
            }

            let rows = monsterRows(in: html)
            print("Fetched page \(current) of \(total) for \(region.rawValue) (\(rows.count) rows)")
            for (id, name) in rows where !name.isEmpty {
                monsterNames[id] = name
            }

            if current >= total {
                break
            }
            page += 1

            // Be polite to divine-pride and pause between pages.
            try await Task.sleep(for: .seconds(1))
        }

        let filled = fillMissingNames(in: &monsterNames, using: englishNames)
        print("Filled \(filled) monster names from monsters with the same English name")

        let lines = monsterNames.keys.sorted().map { "\($0),\(monsterNames[$0]!)" }
        let contents = lines.joined(separator: "\n") + "\n"

        try FileManager.default.createDirectory(at: output.deletingLastPathComponent(), withIntermediateDirectories: true)
        try contents.write(to: output, atomically: true, encoding: .utf8)
        print("Wrote \(monsterNames.count) monster names to \(output.path)")
    }

    private func setPreference(_ parameters: [String : String], with session: URLSession) async throws {
        var components = URLComponents()
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            + [URLQueryItem(name: "returnUrl", value: "/database/monster")]

        var request = URLRequest(url: Self.baseURL.appending(path: "account/set-preference"))
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.percentEncodedQuery?.data(using: .utf8)

        let (_, response) = try await session.data(for: request)
        try checkStatus(of: response)
    }

    private func fetchMonsterListPage(_ page: Int, with session: URLSession) async throws -> String {
        var components = URLComponents(url: Self.baseURL.appending(path: "database/monster"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "page", value: String(page))]

        let (data, response) = try await session.data(from: components.url!)
        try checkStatus(of: response)

        guard let html = String(data: data, encoding: .utf8) else {
            throw ValidationError("Page \(page) is not valid UTF-8.")
        }
        return html
    }

    private func checkStatus(of response: URLResponse) throws {
        if let response = response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
            throw ValidationError("\(response.url?.absoluteString ?? "") returned HTTP \(response.statusCode).")
        }
    }

    // MARK: - mob_db.yml

    /// Reads `Id` → `Name` from rAthena's `mob_db.yml`. Each entry is a
    /// `  - Id:` line followed by its indented fields, so a line-based scan is
    /// enough and avoids pulling in a YAML parser.
    private func fetchEnglishNames(with session: URLSession) async throws -> [Int : String] {
        let mobDBURL = URL(string: "https://raw.githubusercontent.com/arkadeleon/swift-rathena/master/db/re/mob_db.yml")!
        let (data, response) = try await session.data(from: mobDBURL)
        try checkStatus(of: response)

        guard let yaml = String(data: data, encoding: .utf8) else {
            throw ValidationError("mob_db.yml is not valid UTF-8.")
        }

        var englishNames: [Int : String] = [:]
        var currentID: Int?
        for line in yaml.split(separator: "\n", omittingEmptySubsequences: false) {
            if let match = line.firstMatch(of: /^  - Id: (\d+)\s*$/) {
                currentID = Int(match.1)
            } else if let id = currentID, let match = line.firstMatch(of: /^    Name: (.*?)\s*$/) {
                var name = Substring(match.1)
                if name.count >= 2, let first = name.first, first == "\"" || first == "'", name.last == first {
                    name = name.dropFirst().dropLast()
                }
                englishNames[id] = String(name)
            }
        }
        return englishNames
    }

    /// Gives every monster in `mob_db.yml` that has no translated name the
    /// translation of the lowest-numbered monster with the same English name.
    /// Returns how many names were filled in.
    private func fillMissingNames(in monsterNames: inout [Int : String], using englishNames: [Int : String]) -> Int {
        let idsByEnglishName = Dictionary(grouping: englishNames.keys, by: { englishNames[$0]! })

        var filled = 0
        for (id, englishName) in englishNames where monsterNames[id] == nil {
            let donors = idsByEnglishName[englishName]!.sorted()
            if let donor = donors.first(where: { monsterNames[$0] != nil }) {
                monsterNames[id] = monsterNames[donor]
                filled += 1
            }
        }
        return filled
    }

    // MARK: - HTML parsing

    private func monsterRows(in html: String) -> [(id: Int, name: String)] {
        // The name link inside each row of the monster table.
        let rowRegex = /<a href="\/database\/monster\/(\d+)" onclick="event\.stopPropagation\(\)"[^>]*>([^<]*)<\/a>/
        return html.matches(of: rowRegex).compactMap { match in
            guard let id = Int(match.1) else {
                return nil
            }
            let name = unescapeHTML(String(match.2)).trimmingCharacters(in: .whitespacesAndNewlines.union(.controlCharacters))
            return (id, name)
        }
    }

    private func pageIndex(in html: String) -> (current: Int, total: Int)? {
        guard let match = html.firstMatch(of: /Page (\d+) of (\d+)/),
              let current = Int(match.1),
              let total = Int(match.2) else {
            return nil
        }
        return (current, total)
    }

    /// Decodes the named and numeric character references that show up in
    /// monster names; the page is otherwise plain UTF-8.
    private func unescapeHTML(_ string: String) -> String {
        guard string.contains("&") else {
            return string
        }

        let named: [String : String] = [
            "amp": "&", "lt": "<", "gt": ">", "quot": "\"", "apos": "'", "nbsp": "\u{A0}",
        ]

        return string.replacing(/&(#x[0-9A-Fa-f]+|#\d+|[A-Za-z]+);/) { match in
            let reference = String(match.1)
            if reference.hasPrefix("#x"), let code = UInt32(reference.dropFirst(2), radix: 16), let scalar = Unicode.Scalar(code) {
                return String(Character(scalar))
            }
            if reference.hasPrefix("#"), let code = UInt32(reference.dropFirst()), let scalar = Unicode.Scalar(code) {
                return String(Character(scalar))
            }
            return named[reference] ?? String(match.0)
        }
    }
}
