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
    struct Input {
        var jobinheritlist: URL
        var skillid: URL
        var skillinfolist: URL
        var skilldescript: URL
        var skillinfo_f: URL

        /// - Parameter directory: `skillinfoz` directory
        init(directory: URL) {
            jobinheritlist = directory.appendingPathIgnoringCase("jobinheritlist.lub")
            skillid = directory.appendingPathIgnoringCase("skillid.lub")
            skillinfolist = directory.appendingPathIgnoringCase("skillinfolist.lub")
            skilldescript = directory.appendingPathIgnoringCase("skilldescript.lub")
            skillinfo_f = directory.appendingPathIgnoringCase("skillinfo_f.lub")
        }
    }

    func convert(from input: Input, to output: URL, for locale: Locale) throws {
        print("Converting skill info for \(locale.path)")

        let context = LuaContext()
        context.loadJSONModule()

        context.loadData(at: input.jobinheritlist)
        context.loadData(at: input.skillid)

        // Skill IDs renamed in kRO that older localized files still reference.
        // Only fill in the old name when the loaded table doesn't define it itself.
        try context.evaluate("""
        SKID.BA_FROSTJOKE = SKID.BA_FROSTJOKE or SKID.BA_FROSTJOKER
        SKID.MH_SONIC_CRAW = SKID.MH_SONIC_CRAW or SKID.MH_SONIC_CLAW
        """)

        context.loadData(at: input.skillinfolist)
        context.loadData(at: input.skilldescript)
        context.loadData(at: input.skillinfo_f)

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
        let jsonURL = output.appendingPathComponents([locale.path, "SkillInfo.json"])

        try FileManager.default.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try jsonData.write(to: jsonURL)
    }
}
