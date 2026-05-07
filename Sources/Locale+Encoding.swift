//
//  Locale+Encoding.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2025/8/4.
//

import Foundation

let locales = [
    Locale(identifier: "zh-Hans"),
    Locale(identifier: "zh-Hant"),
    Locale(identifier: "en"),
    Locale(identifier: "fr"),
    Locale(identifier: "de"),
    Locale(identifier: "id"),
    Locale(identifier: "it"),
    Locale(identifier: "ja"),
    Locale(identifier: "ko"),
    Locale(identifier: "pt-BR"),
    Locale(identifier: "ru"),
    Locale(identifier: "es"),
    Locale(identifier: "th"),
    Locale(identifier: "tr"),
]

extension Locale {
    var path: String {
        identifier.replacingOccurrences(of: "_", with: "-") + ".lproj"
    }

    var preferredEncoding: String.Encoding {
        let identifier = identifier.lowercased().replacingOccurrences(of: "_", with: "-")
        let languageCode = identifier.split(separator: "-").first.map(String.init) ?? identifier

        let cfEncoding = switch languageCode {
        case "ar":
            CFStringConvertWindowsCodepageToEncoding(1256)
        case "zh" where identifier.contains("hans"):
            CFStringConvertWindowsCodepageToEncoding(936)
        case "zh" where identifier.contains("hant"):
            CFStringConvertWindowsCodepageToEncoding(950)
        case "ja":
            CFStringConvertWindowsCodepageToEncoding(932)
        case "ko":
            CFStringConvertWindowsCodepageToEncoding(949)
        case "ru":
            CFStringConvertWindowsCodepageToEncoding(1251)
        case "es" where identifier.contains("419"):
            CFStringConvertWindowsCodepageToEncoding(1145)
        case "th":
            CFStringConvertWindowsCodepageToEncoding(874)
        case "tr":
            CFStringConvertWindowsCodepageToEncoding(1254)
        case "vi":
            CFStringConvertWindowsCodepageToEncoding(1258)
        default:
            CFStringConvertWindowsCodepageToEncoding(1252)
        }

        let nsEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding)
        let encoding = String.Encoding(rawValue: nsEncoding)
        return encoding
    }
}
