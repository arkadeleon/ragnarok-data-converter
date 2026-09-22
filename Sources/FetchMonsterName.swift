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
