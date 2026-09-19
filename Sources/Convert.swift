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
        try ItemCommonInfoConverter().convert(from: input, to: output)

        try convertItemInfo()

        for locale in locales {
            let converter = ItemRandomOptionNameConverter()
            try converter.convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            let converter = MapNameConverter()
            try converter.convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            let converter = MessageStringConverter()
            try converter.convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            let converter = MonsterNameConverter()
            try converter.convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            let converter = SkillInfoConverter()
            try converter.convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            let converter = StatusInfoConverter()
            try converter.convert(from: input, to: output, for: locale)
        }
    }

    func convertItemInfo() throws {
        let converter = ItemInfoConverter()
        try converter.convert(from: .txt(input), to: output, for: .de)
        try converter.convert(from: .txt(input), to: output, for: .en)
        try converter.convert(from: .txt(input), to: output, for: .es)
        try converter.convert(from: .txt(input), to: output, for: .fr)
        try converter.convert(from: .txt(input), to: output, for: .id)
        try converter.convert(from: .txt(input), to: output, for: .it)
        try converter.convert(from: .txt(input), to: output, for: .ja)
        try converter.convert(from: .lua(input, "itemInfo_true.lub"), to: output, for: .ko)
        try converter.convert(from: .lua(input, "iteminfo_new.lub"), to: output, for: .ptBR, encoding: .utf8)
        try converter.convert(from: .txt(input), to: output, for: .ru)
        try converter.convert(from: .lua(input, "itemInfo_new.lub"), to: output, for: .th, encoding: .utf8)
        try converter.convert(from: .txt(input), to: output, for: .tr)
        try converter.convert(from: .lua(input, "itemInfo.lub"), to: output, for: .zhHans)
        try converter.convert(from: .txt(input), to: output, for: .zhHant)
    }
}
