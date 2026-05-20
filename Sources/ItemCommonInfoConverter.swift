//
//  ItemCommonInfoConverter.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2026/5/20.
//

import Foundation
import RagnarokLua

struct ItemCommonInfo: Codable {
    var unidentifiedItemResourceName: String?
    var identifiedItemResourceName: String?
    var slotCount: Int?
}

struct ItemCommonInfoConverter {
    func convert(from input: URL, to output: URL) throws {
        let locale = Locale(identifier: "ko")
        var itemCommonInfos = try itemCommonInfos(from: input, for: locale)

        for itemID in itemCommonInfos.keys {
            itemCommonInfos[itemID]?.unidentifiedItemResourceName?.transcode(from: .isoLatin1, to: locale.preferredEncoding)
            itemCommonInfos[itemID]?.identifiedItemResourceName?.transcode(from: .isoLatin1, to: locale.preferredEncoding)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(itemCommonInfos)
        let jsonURL = output.appendingPathComponents("Common", "ItemCommonInfo.json")

        try FileManager.default.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try jsonData.write(to: jsonURL)
    }

    private func itemCommonInfos(from input: URL, for locale: Locale) throws -> [String : ItemCommonInfo] {
        let context = LuaContext()
        context.loadJSONModule()

        let itemInfoURL = input.appendingPathComponents(locale.path, "itemInfo.lub")
        context.loadData(at: itemInfoURL)

        try context.parse("""
        function convert()
          local result = {}
          for itemID, value in pairs(tbl) do
            local key = string.format("%07d", itemID)
            result[key] = {
              unidentifiedItemResourceName = value["unidentifiedResourceName"],
              identifiedItemResourceName = value["identifiedResourceName"],
              slotCount = value["slotCount"]
            }
          end
        
          return dkjson.encode(result, { indent = true })
        end
        """)

        let json = try context.call("convert", with: []) as! String

        let decoder = JSONDecoder()
        let itemCommonInfos = try decoder.decode([String : ItemCommonInfo].self, from: json.data(using: .utf8)!)
        return itemCommonInfos
    }
}
