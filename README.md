# Ragnarok Data Converter

![Swift 6.0](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift&logoColor=white)
![Platform macOS 13+](https://img.shields.io/badge/Platform-macOS%2013%2B-000000)
![License GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)

Convert Ragnarok Online client resource files into normalized JSON datasets organized by locale.

This project reads a mix of legacy text tables and Lua-based `.lub` resources, applies locale-aware character transcoding, and writes stable, pretty-printed JSON that is easier to consume from modern tools and applications.

## Features

- Converts multiple Ragnarok Online data sources in one pass.
- Preserves locale-specific encodings for supported client languages.
- Outputs deterministic JSON with sorted keys and readable formatting.
- Handles both Lua-backed and text-backed item data depending on the source files available.
- Skips optional datasets automatically when a locale does not provide the required source file.

## Requirements

- macOS 13 or later
- Swift 6.0 or later

## Quick Start

Run directly from source:

```bash
swift run ragnarok-data-converter ./Input ./Output
```

Or build a release binary first:

```bash
swift build -c release
.build/release/ragnarok-data-converter ./Input ./Output
```

CLI usage:

```text
USAGE: convert <input> <output>
```

The converter expects:

- `input`: a directory containing Ragnarok Online client resource files
- `output`: a directory where converted JSON files will be written

## Generated Output

Output is written per locale using the same `*.lproj` directory convention as the source data:

```text
Output/
  en.lproj/
  ko.lproj/
  zh-Hans.lproj/
  ...
```

Available JSON datasets include:

| Output file | Description |
| --- | --- |
| `ItemInfo.json` | Item names and descriptions |
| `ItemRandomOptionName.json` | Random option display names |
| `MapName.json` | Map internal names to display names |
| `MessageString.json` | Indexed message string table |
| `MonsterName.json` | Monster ID to localized name |
| `SkillInfo.json` | Skill names and descriptions |
| `StatusInfo.json` | Status effect descriptions |

Some files are only generated when the corresponding source files exist for a locale.

## Supported Locales

The repository currently includes input data for:

`de`, `en`, `es`, `fr`, `id`, `it`, `ja`, `ko`, `pt-BR`, `ru`, `th`, `tr`, `zh-Hans`, `zh-Hant`

## Project Layout

```text
.
├── Input/      # Source Ragnarok Online resource files
├── Output/     # Example generated JSON output
├── Sources/    # Swift converters and Lua bridge code
├── Package.swift
└── README.md
```

## Notes

- The converter uses `swift-argument-parser` for the CLI and `swift-lua` for evaluating Lua-based game data.
- Source files may use different legacy encodings depending on locale; the converter normalizes them during export.

## License

This project is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for details.

## Asset Copyright

The Ragnarok Online resource files in `Input/` are copyrighted by Gravity Co., Ltd.
Use and redistribution of game assets should follow the rights granted by their respective owners.
