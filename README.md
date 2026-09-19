# Ragnarok Data Converter

![Swift 6.0](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift&logoColor=white)
![Platform macOS](https://img.shields.io/badge/Platform-macOS-000000)
![License GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)

Convert Ragnarok Online client resource files into normalized JSON datasets.

## Requirements

- macOS with a Swift 6-compatible toolchain

## Usage

```bash
swift run ragnarok-data-converter <input> <output>
```

- `input`: directory containing one subdirectory per Ragnarok Online client (see below)
- `output`: directory where JSON files will be written

## Input

Each client is kept as it ships, under a directory named after the region it serves. Which files are read for which locale is spelled out per client in `Convert.swift`.

```text
Input/
  Korea/          data/ System/                  → ko
  International/  data/ System/                  → en
  Japan/          data/ System/                  → ja
  China/          data/ System/ mobname.txt      → zh-Hans
  Taiwan/         data/ System/ mobname.txt      → zh-Hant
  Brazil/         data/ System/                  → pt-BR
  Thailand/       data/ System/                  → th
  Indonesia/      data/ System/                  → id
  Russia/         data/ System/                  → ru
  Europe/         data/{german,spanish,french,italian,turkish}/ …
                  data/luafiles514/{german,…}/lua files/ …
                                                 → de, es, fr, it, tr
```

Single-language clients keep everything in `data/` and `System/`. The euRO client ships one subdirectory per language with only the translated files, and falls back to the root of `data/` for the rest.

## Output

Locale-independent data is written to `Common/`; locale-specific data is written per locale using `*.lproj` directory names.

```text
Output/
  Common/
    ItemCommonInfo.json
  en.lproj/
    ItemInfo.json
    ...
  ko.lproj/
  zh-Hans.lproj/
  ...
```

| File | Description |
| --- | --- |
| `Common/ItemCommonInfo.json` | Locale-independent item properties |
| `ItemInfo.json` | Item names and descriptions |
| `ItemRandomOptionName.json` | Random option display names |
| `MapInfo.json` | Map display names and sign titles |
| `MessageString.json` | Indexed message string table |
| `MonsterName.json` | Monster names |
| `SkillInfo.json` | Skill names and descriptions |
| `StatusInfo.json` | Status effect descriptions |

Some files are only generated when the corresponding source files exist for a locale.

## Supported Locales

`de`, `en`, `es`, `fr`, `id`, `it`, `ja`, `ko`, `pt-BR`, `ru`, `th`, `tr`, `zh-Hans`, `zh-Hant`

## License

This project is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for details.

## Asset Copyright

The Ragnarok Online resource files in `Input/` are copyrighted by Gravity Co., Ltd.
Use and redistribution of game assets should follow the rights granted by their respective owners.
