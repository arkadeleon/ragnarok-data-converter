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

- `input`: directory containing Ragnarok Online client resource files
- `output`: directory where JSON files will be written

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
| `MapName.json` | Map display names |
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
