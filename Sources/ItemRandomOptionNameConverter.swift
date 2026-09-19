//
//  ItemRandomOptionNameConverter.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2025/8/5.
//

import Foundation
import RagnarokLua

struct ItemRandomOptionNameConverter {
    struct Input {
        var enumvar: URL
        var addrandomoptionnametable: URL

        /// - Parameter directory: `datainfo` directory
        init(directory: URL) {
            enumvar = directory.appendingPathIgnoringCase("enumvar.lub")
            addrandomoptionnametable = directory.appendingPathIgnoringCase("addrandomoptionnametable.lub")
        }
    }

    func convert(from input: Input, to output: URL, for locale: Locale) throws {
        print("Converting item random option name for \(locale.path)")

        let context = LuaContext()
        context.loadJSONModule()

        context.loadData(at: input.enumvar)
        context.loadData(at: input.addrandomoptionnametable)

        try context.evaluate("""
        function convert()
          return dkjson.encode(NameTable_VAR, { indent = true })
        end
        """)

        let json = try context.call("convert", with: []).stringValue!

        let decoder = JSONDecoder()
        let names = try decoder.decode([String?].self, from: json.data(using: .utf8)!)

        let itemRandomOptionNames = Dictionary(
            names.enumerated().map({ (String(format: "%03d", $0.offset + 1), $0.element) }),
            uniquingKeysWith: { first, _ in first }
        ).compactMapValues { name in
            name?.transcoding(from: .isoLatin1, to: locale.preferredEncoding)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(itemRandomOptionNames)
        let jsonURL = output.appendingPathComponents([locale.path, "ItemRandomOptionName.json"])

        try FileManager.default.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try jsonData.write(to: jsonURL)
    }
}
