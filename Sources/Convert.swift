//
//  Convert.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2025/8/1.
//

import ArgumentParser
import Foundation

@main
struct Convert: ParsableCommand {
    @Argument(transform: { URL(fileURLWithPath: $0, isDirectory: true) })
    var input: URL

    @Argument(transform: { URL(fileURLWithPath: $0, isDirectory: true) })
    var output: URL

    func run() throws {
        try convertBrazil()
        try convertChina()
        try convertEurope()
        try convertIndonesia()
        try convertInternational()
        try convertJapan()
        try convertKorea()
        try convertLatinAmerica()
        try convertRussia()
        try convertTaiwan()
        try convertThailand()
    }

    func convertBrazil() throws {
        let root = input.appendingPathIgnoringCase("Brazil")

        try ItemInfoConverter().convert(
            from: .lua(itemInfoURL: root.appendingPathIgnoringCase("System/iteminfo_new.lub")),
            to: output, for: .ptBR, encoding: .utf8
        )
        try MapInfoConverter().convert(
            from: .lua(mapInfoURL: root.appendingPathIgnoringCase("System/mapInfo.lub")),
            to: output, for: .ptBR
        )
        try ItemRandomOptionNameConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/datainfo")),
            to: output, for: .ptBR
        )
        try MessageStringConverter().convert(
            from: .txt(msgStringTableURL: root.appendingPathIgnoringCase("data/msgstringtable.txt")),
            to: output, for: .ptBR
        )
        try SkillInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz")),
            to: output, for: .ptBR
        )
        try StatusInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon")),
            to: output, for: .ptBR
        )
    }

    func convertChina() throws {
        let root = input.appendingPathIgnoringCase("China")

        try ItemInfoConverter().convert(
            from: .lua(itemInfoURL: root.appendingPathIgnoringCase("System/iteminfo_new.lub")),
            to: output, for: .zhHans, encoding: .utf8
        )
        try MapInfoConverter().convert(
            from: .lua(mapInfoURL: root.appendingPathIgnoringCase("System/mapInfo.lub")),
            to: output, for: .zhHans
        )
        try ItemRandomOptionNameConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/datainfo")),
            to: output, for: .zhHans
        )
        try MessageStringConverter().convert(
            from: .csv(msgStringTableURL: root.appendingPathIgnoringCase("data/msgstringtable.csv"), column: 1),
            to: output, for: .zhHans
        )
        try MonsterNameConverter().convert(
            from: root.appendingPathIgnoringCase("mobname.txt"),
            to: output, for: .zhHans
        )
        try SkillInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz")),
            to: output, for: .zhHans
        )
        try StatusInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon")),
            to: output, for: .zhHans
        )
    }

    /// The euRO client keeps one language per subdirectory (`data/german/…`,
    /// `data/luafiles514/german/lua files/…`) and only ships the files that were
    /// actually translated there; everything else lives at the root of `data/`.
    func convertEurope() throws {
        let root = input.appendingPathIgnoringCase("Europe")

        let languages: [(Locale, String)] = [
            (.de, "german"),
            (.fr, "french"),
            (.it, "italian"),
            (.tr, "turkish"),
        ]

        for (locale, language) in languages {
            let data = root.appendingPathIgnoringCase("data/\(language)")
            let luaFiles = root.appendingPathIgnoringCase("data/luafiles514/\(language)/lua files")

            try ItemInfoConverter().convert(
                from: .txt(
                    displayNameTableURL: data.appendingPathIgnoringCase("idnum2itemdisplaynametable.txt"),
                    descriptionTableURL: data.appendingPathIgnoringCase("idnum2itemdesctable.txt")
                ),
                to: output, for: locale
            )
            try MapInfoConverter().convert(
                from: .txt(mapNameTableURL: data.appendingPathIgnoringCase("mapnametable.txt")),
                to: output, for: locale
            )
            try MessageStringConverter().convert(
                from: .txt(msgStringTableURL: data.appendingPathIgnoringCase("msgstringtable.txt")),
                to: output, for: locale
            )

            var skillInfoInput = SkillInfoConverter.Input(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz"))
            skillInfoInput.skillinfolist = luaFiles.appendingPathIgnoringCase("skillinfoz/skillinfolist.lub")
            skillInfoInput.skilldescript = luaFiles.appendingPathIgnoringCase("skillinfoz/skilldescript.lub")
            try SkillInfoConverter().convert(from: skillInfoInput, to: output, for: locale)

            var statusInfoInput = StatusInfoConverter.Input(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon"))
            statusInfoInput.stateiconinfo = luaFiles.appendingPathIgnoringCase("stateicon/stateiconinfo.lub")
            try StatusInfoConverter().convert(from: statusInfoInput, to: output, for: locale)
        }
    }

    func convertIndonesia() throws {
        let root = input.appendingPathIgnoringCase("Indonesia")

        try ItemInfoConverter().convert(
            from: .lua(itemInfoURL: root.appendingPathIgnoringCase("System/iteminfo_new.lub")),
            to: output, for: .id, encoding: .utf8
        )
        try MapInfoConverter().convert(
            from: .txt(mapNameTableURL: root.appendingPathIgnoringCase("data/mapnametable.txt")),
            to: output, for: .id
        )
        try ItemRandomOptionNameConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/datainfo")),
            to: output, for: .id
        )
        try MessageStringConverter().convert(
            from: .txt(msgStringTableURL: root.appendingPathIgnoringCase("data/msgstringtable.txt")),
            to: output, for: .id
        )
        try SkillInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz")),
            to: output, for: .id
        )
        try StatusInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon")),
            to: output, for: .id
        )
    }

    func convertInternational() throws {
        let root = input.appendingPathIgnoringCase("International")

        try ItemInfoConverter().convert(
            from: .lua(itemInfoURL: root.appendingPathIgnoringCase("System/iteminfo.lub")),
            to: output, for: .en
        )
        try MapInfoConverter().convert(
            from: .lua(mapInfoURL: root.appendingPathIgnoringCase("System/mapInfo.lub")),
            to: output, for: .en
        )
        try ItemRandomOptionNameConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/datainfo")),
            to: output, for: .en
        )
        try MessageStringConverter().convert(
            from: .txt(msgStringTableURL: root.appendingPathIgnoringCase("data/msgstringtable.txt")),
            to: output, for: .en
        )
        try SkillInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz")),
            to: output, for: .en
        )
        try StatusInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon")),
            to: output, for: .en
        )
    }

    func convertJapan() throws {
        let root = input.appendingPathIgnoringCase("Japan")

        try ItemInfoConverter().convert(
            from: .txt(
                displayNameTableURL: root.appendingPathIgnoringCase("data/idnum2itemdisplaynametable.txt"),
                descriptionTableURL: root.appendingPathIgnoringCase("data/idnum2itemdesctable.txt")
            ),
            to: output, for: .ja
        )
        try MapInfoConverter().convert(
            from: .txt(mapNameTableURL: root.appendingPathIgnoringCase("data/mapnametable.txt")),
            to: output, for: .ja
        )
        try ItemRandomOptionNameConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/datainfo")),
            to: output, for: .ja
        )
        try MessageStringConverter().convert(
            from: .txt(msgStringTableURL: root.appendingPathIgnoringCase("data/msgstringtable.txt")),
            to: output, for: .ja
        )
        try SkillInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz")),
            to: output, for: .ja
        )
        try StatusInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon")),
            to: output, for: .ja
        )
    }

    func convertKorea() throws {
        let root = input.appendingPathIgnoringCase("Korea")

        try ItemCommonInfoConverter().convert(
            from: root.appendingPathIgnoringCase("System/itemInfo_true.lub"),
            to: output
        )

        try ItemInfoConverter().convert(
            from: .lua(itemInfoURL: root.appendingPathIgnoringCase("System/itemInfo_true.lub")),
            to: output, for: .ko
        )
        try MapInfoConverter().convert(
            from: .lua(mapInfoURL: root.appendingPathIgnoringCase("System/mapInfo_true.lub")),
            to: output, for: .ko
        )
        try ItemRandomOptionNameConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/datainfo")),
            to: output, for: .ko
        )
        try MessageStringConverter().convert(
            from: .csv(msgStringTableURL: root.appendingPathIgnoringCase("data/MsgStringTable.csv"), column: 1),
            to: output, for: .ko
        )
        try SkillInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz")),
            to: output, for: .ko
        )
        try StatusInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon")),
            to: output, for: .ko
        )
    }

    /// The latam client is Portuguese at the root and keeps the other languages
    /// under `System/spanish/…` and `data/spanish/LuaFiles514/…` (euRO style), while
    /// message strings only exist in the multi-language CSV.
    func convertLatinAmerica() throws {
        let root = input.appendingPathIgnoringCase("LatinAmerica")

        let languages: [(Locale, String, Int)] = [
            (.es, "spanish", 9),
        ]

        for (locale, language, messageStringColumn) in languages {
            let system = root.appendingPathIgnoringCase("System/\(language)")
            let luaFiles = root.appendingPathIgnoringCase("data/\(language)/LuaFiles514/lua files")

            try ItemInfoConverter().convert(
                from: .lua(itemInfoURL: system.appendingPathIgnoringCase("iteminfo_new.lub")),
                to: output, for: locale, encoding: .utf8
            )
            try MapInfoConverter().convert(
                from: .lua(mapInfoURL: system.appendingPathIgnoringCase("mapInfo.lub")),
                to: output, for: locale
            )

            var itemRandomOptionNameInput = ItemRandomOptionNameConverter.Input(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/datainfo"))
            itemRandomOptionNameInput.addrandomoptionnametable = luaFiles.appendingPathIgnoringCase("datainfo/addrandomoptionnametable.lub")
            try ItemRandomOptionNameConverter().convert(from: itemRandomOptionNameInput, to: output, for: locale)

            try MessageStringConverter().convert(
                from: .csv(msgStringTableURL: root.appendingPathIgnoringCase("data/MsgStringTable_ml.csv"), column: messageStringColumn),
                to: output, for: locale
            )

            var skillInfoInput = SkillInfoConverter.Input(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz"))
            skillInfoInput.skillinfolist = luaFiles.appendingPathIgnoringCase("skillinfoz/skillinfolist.lub")
            skillInfoInput.skilldescript = luaFiles.appendingPathIgnoringCase("skillinfoz/skilldescript.lub")
            try SkillInfoConverter().convert(from: skillInfoInput, to: output, for: locale)

            var statusInfoInput = StatusInfoConverter.Input(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon"))
            statusInfoInput.stateiconinfo = luaFiles.appendingPathIgnoringCase("stateicon/stateiconinfo.lub")
            try StatusInfoConverter().convert(from: statusInfoInput, to: output, for: locale)
        }
    }

    func convertRussia() throws {
        let root = input.appendingPathIgnoringCase("Russia")

        try ItemInfoConverter().convert(
            from: .txt(
                displayNameTableURL: root.appendingPathIgnoringCase("data/idnum2itemdisplaynametable.txt"),
                descriptionTableURL: root.appendingPathIgnoringCase("data/idnum2itemdesctable.txt")
            ),
            to: output, for: .ru
        )
        try MapInfoConverter().convert(
            from: .txt(mapNameTableURL: root.appendingPathIgnoringCase("data/mapnametable.txt")),
            to: output, for: .ru
        )
        try MessageStringConverter().convert(
            from: .txt(msgStringTableURL: root.appendingPathIgnoringCase("data/msgstringtable.txt")),
            to: output, for: .ru
        )
        try SkillInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz")),
            to: output, for: .ru
        )
        try StatusInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon")),
            to: output, for: .ru
        )
    }

    func convertTaiwan() throws {
        let root = input.appendingPathIgnoringCase("Taiwan")

        try ItemInfoConverter().convert(
            from: .lua(itemInfoURL: root.appendingPathIgnoringCase("System/iteminfo_new.lub")),
            to: output, for: .zhHant, encoding: .utf8
        )
        try MapInfoConverter().convert(
            from: .lua(mapInfoURL: root.appendingPathIgnoringCase("System/mapInfo.lub")),
            to: output, for: .zhHant
        )
        try ItemRandomOptionNameConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/datainfo")),
            to: output, for: .zhHant
        )
        try MessageStringConverter().convert(
            from: .csv(msgStringTableURL: root.appendingPathIgnoringCase("data/MsgStringTable.csv"), column: 1),
            to: output, for: .zhHant
        )
        try MonsterNameConverter().convert(
            from: root.appendingPathIgnoringCase("mobname.txt"),
            to: output, for: .zhHant
        )
        try SkillInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz")),
            to: output, for: .zhHant
        )
        try StatusInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon")),
            to: output, for: .zhHant
        )
    }

    func convertThailand() throws {
        let root = input.appendingPathIgnoringCase("Thailand")

        try ItemInfoConverter().convert(
            from: .lua(itemInfoURL: root.appendingPathIgnoringCase("System/itemInfo_new.lub")),
            to: output, for: .th, encoding: .utf8
        )
        try MapInfoConverter().convert(
            from: .lua(mapInfoURL: root.appendingPathIgnoringCase("System/mapInfo.lub")),
            to: output, for: .th
        )
        try ItemRandomOptionNameConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/datainfo")),
            to: output, for: .th
        )
        try MessageStringConverter().convert(
            from: .txt(msgStringTableURL: root.appendingPathIgnoringCase("data/msgstringtable.txt")),
            to: output, for: .th
        )
        try SkillInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/skillinfoz")),
            to: output, for: .th
        )
        try StatusInfoConverter().convert(
            from: .init(directory: root.appendingPathIgnoringCase("data/luafiles514/lua files/stateicon")),
            to: output, for: .th
        )
    }
}
