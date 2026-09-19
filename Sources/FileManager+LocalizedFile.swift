//
//  FileManager+LocalizedFile.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2026/9/19.
//

import Foundation

extension FileManager {
    func localizedFileURL(in input: URL, for locale: Locale, pathComponents: [String]) -> URL {
        let localizedURL = input.appendingPathComponentsIgnoringCase([locale.path] + pathComponents)
        if fileExists(atPath: localizedURL.path) {
            return localizedURL
        }
        return input.appendingPathComponentsIgnoringCase(["ko.lproj"] + pathComponents)
    }
}
