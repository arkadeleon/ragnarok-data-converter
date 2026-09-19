//
//  Locale+Encoding.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2025/8/4.
//

import Foundation

let locales: [Locale] = [
    .de,
    .en,
    .es,
    .fr,
    .id,
    .it,
    .ja,
    .ko,
    .ptBR,
    .ru,
    .th,
    .tr,
    .zhHans,
    .zhHant,
]

extension Locale {
    static let de = Locale(identifier: "de")
    static let en = Locale(identifier: "en")
    static let es = Locale(identifier: "es")
    static let fr = Locale(identifier: "fr")
    static let id = Locale(identifier: "id")
    static let it = Locale(identifier: "it")
    static let ja = Locale(identifier: "ja")
    static let ko = Locale(identifier: "ko")
    static let ptBR = Locale(identifier: "pt-BR")
    static let ru = Locale(identifier: "ru")
    static let th = Locale(identifier: "th")
    static let tr = Locale(identifier: "tr")
    static let zhHans = Locale(identifier: "zh-Hans")
    static let zhHant = Locale(identifier: "zh-Hant")
}

extension Locale {
    var path: String {
        identifier.replacingOccurrences(of: "_", with: "-") + ".lproj"
    }

    var preferredEncoding: String.Encoding {
        let identifier = identifier.lowercased().replacingOccurrences(of: "_", with: "-")
        let languageCode = identifier.split(separator: "-").first.map(String.init) ?? identifier

        return switch languageCode {
        case "ar":
            .cp1256
        case "zh" where identifier.contains("hans"):
            .cp936
        case "zh" where identifier.contains("hant"):
            .cp950
        case "ja":
            .cp932
        case "ko":
            .cp949
        case "ru":
            .cp1251
        case "es" where identifier.contains("419"):
            .cp1145
        case "th":
            .cp874
        case "tr":
            .cp1254
        case "vi":
            .cp1258
        default:
            .cp1252
        }
    }
}

extension String.Encoding {
    static let cp874 = String.Encoding(windowsCodepage: 874)
    static let cp932 = String.Encoding(windowsCodepage: 932)
    static let cp936 = String.Encoding(windowsCodepage: 936)
    static let cp949 = String.Encoding(windowsCodepage: 949)
    static let cp950 = String.Encoding(windowsCodepage: 950)
    static let cp1145 = String.Encoding(windowsCodepage: 1145)
    static let cp1251 = String.Encoding(windowsCodepage: 1251)
    static let cp1252 = String.Encoding(windowsCodepage: 1252)
    static let cp1254 = String.Encoding(windowsCodepage: 1254)
    static let cp1256 = String.Encoding(windowsCodepage: 1256)
    static let cp1258 = String.Encoding(windowsCodepage: 1258)

    init(windowsCodepage: UInt32) {
        let cfEncoding = CFStringConvertWindowsCodepageToEncoding(windowsCodepage)
        let nsEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding)
        self.init(rawValue: nsEncoding)
    }
}
