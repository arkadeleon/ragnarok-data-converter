//
//  StatusInfoConverter.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2025/8/5.
//

import Foundation
import RagnarokLua

struct StatusInfo: Codable {
    var statusDescription: String
}

struct StatusInfoConverter {
    struct Input {
        var efstids: URL
        var stateiconimginfo: URL
        var stateiconinfo: URL

        /// - Parameter directory: `stateicon` directory
        init(directory: URL) {
            efstids = directory.appendingPathIgnoringCase("efstids.lub")
            stateiconimginfo = directory.appendingPathIgnoringCase("stateiconimginfo.lub")
            stateiconinfo = directory.appendingPathIgnoringCase("stateiconinfo.lub")
        }
    }

    func convert(from input: Input, to output: URL, for locale: Locale) throws {
        print("Converting status info for \(locale.path)")

        let context = LuaContext()
        context.loadJSONModule()

        context.loadData(at: input.efstids)
        context.loadData(at: input.stateiconimginfo)
        context.loadData(at: input.stateiconinfo)

        try context.evaluate("""
        function convert()
          local result = {}
          for statusID, value in pairs(StateIconList) do
            local descript = value["descript"]
            if descript and descript[1] and descript[1][1] then
              local key = string.format("%04d", statusID)
              result[key] = {
                statusDescription = descript[1][1]
              }
            end
          end
        
          return dkjson.encode(result, { indent = true })
        end
        """)

        let json = try context.call("convert", with: []).stringValue!

        let decoder = JSONDecoder()
        var statusInfos = try decoder.decode([String : StatusInfo].self, from: json.data(using: .utf8)!)
        for statusID in statusInfos.keys {
            statusInfos[statusID]?.statusDescription.transcode(from: .isoLatin1, to: locale.preferredEncoding)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(statusInfos)
        let jsonURL = output.appendingPathComponents([locale.path, "StatusInfo.json"])

        try FileManager.default.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try jsonData.write(to: jsonURL)
    }
}
