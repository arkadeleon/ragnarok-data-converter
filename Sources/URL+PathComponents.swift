//
//  URL+PathComponents.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2026/5/7.
//

import Foundation

extension URL {
    func appendingPathComponents(_ components: String...) -> URL {
        components.reduce(self) { url, component in
            url.appendingPathComponent(component)
        }
    }
}
