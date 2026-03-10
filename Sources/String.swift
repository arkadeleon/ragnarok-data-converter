//
//  String.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2026/3/10.
//

import Foundation

extension StringProtocol {
    func trimmingWhitespacesAndNewlines() -> String {
        trimmingCharacters(in: CharacterSet(charactersIn: " \t\r\n"))
    }
}

extension String {
    mutating func transcode(from: String.Encoding, to: String.Encoding) {
        let string = data(using: from).flatMap { data in
            String(data: data, encoding: to)
        }
        if let string {
            self = string
        }
    }

    func transcoding(from: String.Encoding, to: String.Encoding) -> String {
        let string = data(using: from).flatMap { data in
            String(data: data, encoding: to)
        }
        return string ?? self
    }
}
