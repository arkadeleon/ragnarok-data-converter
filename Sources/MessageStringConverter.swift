//
//  MessageStringConverter.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2025/8/4.
//

import Foundation

struct MessageStringConverter {
    enum Input {
        case txt(msgStringTableURL: URL)
        case csv(msgStringTableURL: URL, column: Int)
    }

    func convert(from input: Input, to output: URL, for locale: Locale) throws {
        print("Converting message string for \(locale.path)")

        let messageStrings = switch input {
        case .txt(let msgStringTableURL):
            try txtMessageStrings(from: msgStringTableURL, for: locale)
        case .csv(let msgStringTableURL, let column):
            try csvMessageStrings(from: msgStringTableURL, column: column)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(messageStrings)
        let jsonURL = output.appendingPathComponents([locale.path, "MessageString.json"])

        try FileManager.default.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try jsonData.write(to: jsonURL)
    }

    private func txtMessageStrings(from msgStringTableURL: URL, for locale: Locale) throws -> [String : String] {
        let string = try String(contentsOf: msgStringTableURL, encoding: .isoLatin1)

        var messageStrings: [String : String] = [:]

        let lines = string.components(separatedBy: "\r\n").filter { !$0.isEmpty }
        for (lineNumber, line) in lines.enumerated() {
            let messageID = String(format: "%04d", lineNumber)
            var messageString = line.transcoding(from: .isoLatin1, to: locale.preferredEncoding)
            if messageString.hasSuffix("#") {
                messageString.removeLast()
            }
            messageStrings[messageID] = messageString
        }

        return messageStrings
    }

    private func csvMessageStrings(from msgStringTableURL: URL, column: Int) throws -> [String : String] {
        let string = try String(contentsOf: msgStringTableURL, encoding: .utf8)

        var messageStrings: [String : String] = [:]

        let lines = string.components(separatedBy: "\r\n").filter { !$0.isEmpty }
        for (lineNumber, line) in lines.enumerated() {
            let columns = line.split(separator: ",", omittingEmptySubsequences: false)
            guard column < columns.count,
                  let data = Data(base64Encoded: String(columns[column])),
                  let messageString = String(data: data, encoding: .utf8) else {
                continue
            }

            let messageID = String(format: "%04d", lineNumber)

            // Quotes and backslashes are stored C-escaped in the CSV, unlike the txt.
            // `\n`, `\r` and `\t` are literal two-character sequences in both, so leave them.
            messageStrings[messageID] = messageString
                .replacingOccurrences(of: "\\\"", with: "\"")
                .replacingOccurrences(of: "\\'", with: "'")
                .replacingOccurrences(of: "\\\\", with: "\\")
        }

        return messageStrings
    }
}
