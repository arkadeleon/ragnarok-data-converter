//
//  SkillInfoConverter.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2025/8/1.
//

import Foundation
import RagnarokLua

struct SkillInfo: Codable {
    var skillName: String?
    var skillDescription: String?
}

struct SkillInfoConverter {
    func convert(from input: URL, to output: URL, for locale: Locale) throws {
        print("Converting skill info for \(locale.path)")

        let context = LuaContext()
        context.loadJSONModule()

        let jobinheritlistURL = input.appendingPathComponents("ko.lproj", "data", "luafiles514", "lua files", "skillinfoz", "jobinheritlist.lub")
        context.loadData(at: jobinheritlistURL)

        let skillidURL = input.appendingPathComponents("ko.lproj", "data", "luafiles514", "lua files", "skillinfoz", "skillid.lub")
        context.loadData(at: skillidURL)

        let skillinfolistURL = input.appendingPathComponents(locale.path, "data", "luafiles514", "lua files", "skillinfoz", "skillinfolist.lub")
        context.loadData(at: skillinfolistURL)

        let skilldescriptURL = input.appendingPathComponents(locale.path, "data", "luafiles514", "lua files", "skillinfoz", "skilldescript.lub")
        context.loadData(at: skilldescriptURL)

        let skillinfofURL = input.appendingPathComponents("ko.lproj", "data", "luafiles514", "lua files", "skillinfoz", "skillinfo_f.lub")
        context.loadData(at: skillinfofURL)

        try context.evaluate("""
        function convert()
          local result = {}
          for skillAegisName, skillID in pairs(SKID) do
            local key = string.format("%05d", skillID)
        
            local skillName
            if SKILL_INFO_LIST[skillID] and SKILL_INFO_LIST[skillID].SkillName then
              skillName = SKILL_INFO_LIST[skillID].SkillName
            end
        
            local skillDescription
            if SKILL_DESCRIPT[skillID] then
              skillDescription = table.concat(SKILL_DESCRIPT[skillID], "\\r\\n")
            end
        
            if skillName or skillDescription then
              result[key] = {
                skillName = skillName,
                skillDescription = skillDescription
              }
            end
          end
        
          return dkjson.encode(result, { indent = true })
        end
        """)

        let json = try context.call("convert", with: []).stringValue!

        let decoder = JSONDecoder()
        var skillInfos = try decoder.decode([String : SkillInfo].self, from: json.data(using: .utf8)!)
        for skillID in skillInfos.keys {
            skillInfos[skillID]?.skillName?.transcode(from: .isoLatin1, to: locale.preferredEncoding)
            skillInfos[skillID]?.skillDescription?.transcode(from: .isoLatin1, to: locale.preferredEncoding)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(skillInfos)
        let jsonURL = output.appendingPathComponents(locale.path, "SkillInfo.json")

        try FileManager.default.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try jsonData.write(to: jsonURL)
    }
}
