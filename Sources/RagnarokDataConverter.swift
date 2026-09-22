//
//  RagnarokDataConverter.swift
//  ragnarok-data-converter
//
//  Created by Leon Li on 2026/9/22.
//

import ArgumentParser

@main
struct RagnarokDataConverter: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ragnarok-data-converter",
        abstract: "Tools for converting Ragnarok Online client data into JSON datasets.",
        subcommands: [
            Convert.self,
            FetchMonsterName.self,
        ],
        defaultSubcommand: Convert.self
    )
}
