//
//  StatusIconConverter.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2026/10/15.
//

import Foundation
import RagnarokLua

struct StatusIconConverter {
    struct Input {
        var efstids: URL
        var stateiconimginfo: URL

        /// - Parameter directory: `stateicon` directory
        init(directory: URL) {
            efstids = directory.appendingPathIgnoringCase("efstids.lub")
            stateiconimginfo = directory.appendingPathIgnoringCase("stateiconimginfo.lub")
        }
    }

    func convert(from input: Input, to output: URL) throws {
        print("Converting status icon")

        let locale = Locale.ko

        let context = LuaContext()
        context.loadJSONModule()

        context.loadData(at: input.efstids)
        context.loadData(at: input.stateiconimginfo)

        try context.evaluate("""
        function convertStatusIDs()
          local result = {}
          for statusName, statusID in pairs(EFST_IDs) do
            if type(statusName) == "string" and type(statusID) == "number" then
              result[statusName] = statusID
            end
          end

          return dkjson.encode(result, { indent = true })
        end

        function convertStatusIcons()
          local result = {}
          local priorities = { PRIORITY_GOLD, PRIORITY_RED, PRIORITY_BLUE, PRIORITY_GREEN, PRIORITY_WHITE }
          for _, priority in ipairs(priorities) do
            for statusID, iconName in pairs(StateIconImgList[priority] or {}) do
              local key = string.format("%04d", statusID)
              if result[key] == nil then
                result[key] = iconName
              end
            end
          end

          return dkjson.encode(result, { indent = true })
        end
        """)

        let decoder = JSONDecoder()

        let statusIDsJSON = try context.call("convertStatusIDs", with: []).stringValue!
        let statusIDs = try decoder.decode([String : Int].self, from: statusIDsJSON.data(using: .utf8)!)

        let statusIconsJSON = try context.call("convertStatusIcons", with: []).stringValue!
        var statusIcons = try decoder.decode([String : String].self, from: statusIconsJSON.data(using: .utf8)!)
        for statusID in statusIcons.keys {
            statusIcons[statusID]?.transcode(from: .isoLatin1, to: locale.preferredEncoding)
        }

        for (statusName, iconName) in statusIconSupplement {
            guard let statusID = statusIDs[statusName] else {
                print("Unknown status \(statusName) in status icon supplement")
                continue
            }
            let key = String(format: "%04d", statusID)
            if statusIcons[key] == nil {
                statusIcons[key] = iconName
            }
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(statusIcons)
        let jsonURL = output.appendingPathComponents(["Common", "StatusIcon.json"])

        try FileManager.default.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try jsonData.write(to: jsonURL)
    }
}
