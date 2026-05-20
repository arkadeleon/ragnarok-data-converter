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

        for locale in locales {
            print("Converting item info for \(locale.path)")
            try ItemInfoConverter().convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            print("Converting item random option name for \(locale.path)")
            try ItemRandomOptionNameConverter().convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            print("Converting map name for \(locale.path)")
            try MapNameConverter().convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            print("Converting message string for \(locale.path)")
            try MessageStringConverter().convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            print("Converting monster name for \(locale.path)")
            try MonsterNameConverter().convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            print("Converting skill info for \(locale.path)")
            try SkillInfoConverter().convert(from: input, to: output, for: locale)
        }

        for locale in locales {
            print("Converting status info for \(locale.path)")
            try StatusInfoConverter().convert(from: input, to: output, for: locale)
        }
    }
}
