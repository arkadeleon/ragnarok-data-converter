//
//  MapInfoConverter.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2025/8/4.
//

import Foundation
import RagnarokLua

struct MapInfo: Codable {
    var displayName: String?
    var signMainTitle: String?
    var signSubTitle: String?
}

struct MapInfoConverter {
    enum Input {
        case lua(_ url: URL, _ filename: String)
        case txt(_ url: URL)
    }

    func convert(from input: Input, to output: URL, for locale: Locale, encoding: String.Encoding? = nil) throws {
        print("Converting map info for \(locale.path)")

        var mapInfos = switch input {
        case .lua(let url, let filename):
            try luaMapInfos(from: url, filename: filename, for: locale)
        case .txt(let url):
            txtMapInfos(from: url, for: locale)
        }

        let encoding = encoding ?? locale.preferredEncoding

        for rsw in mapInfos.keys {
            mapInfos[rsw]?.displayName?.transcode(from: .isoLatin1, to: encoding)
            mapInfos[rsw]?.signMainTitle?.transcode(from: .isoLatin1, to: encoding)
            mapInfos[rsw]?.signSubTitle?.transcode(from: .isoLatin1, to: encoding)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(mapInfos)
        let jsonURL = output.appendingPathComponents([locale.path, "MapInfo.json"])

        try FileManager.default.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try jsonData.write(to: jsonURL)
    }

    private func luaMapInfos(from input: URL, filename: String, for locale: Locale) throws -> [String : MapInfo] {
        let context = LuaContext()
        context.loadJSONModule()

        let mapInfoURL = input.appendingPathComponentsIgnoringCase([locale.path, "System", filename])
        context.loadData(at: mapInfoURL)

        try context.evaluate("""
        function convert()
          local result = {}
          for rsw, value in pairs(mapTbl) do
            local key = string.gsub(rsw, "%.rsw$", "")
            local signName = value["signName"] or {}
            result[key] = {
              displayName = value["displayName"],
              signMainTitle = signName["mainTitle"],
              signSubTitle = signName["subTitle"]
            }
          end
        
          return dkjson.encode(result, { indent = true })
        end
        """)

        let json = try context.call("convert", with: []).stringValue!

        let decoder = JSONDecoder()
        let mapInfos = try decoder.decode([String : MapInfo].self, from: json.data(using: .utf8)!)
        return mapInfos
    }

    private func txtMapInfos(from input: URL, for locale: Locale) -> [String : MapInfo] {
        let url = input.appendingPathComponentsIgnoringCase([locale.path, "data", "mapnametable.txt"])
        guard let string = try? String(contentsOf: url, encoding: .isoLatin1) else {
            return [:]
        }

        var mapInfos: [String : MapInfo] = [:]

        let lines = string.components(separatedBy: "\r\n").filter { !$0.isEmpty }
        for line in lines {
            if line.trimmingCharacters(in: .whitespaces).starts(with: "//") {
                continue
            }

            let columns = line.split(separator: "#")
            if columns.count >= 2 {
                let rsw = columns[0]
                    .trimmingCharacters(in: .whitespaces)
                    .replacingOccurrences(of: ".rsw", with: "")
                let displayName = columns[1]
                    .trimmingCharacters(in: .whitespaces)
                mapInfos[rsw] = MapInfo(displayName: displayName)
            }
        }

        return mapInfos
    }
}
