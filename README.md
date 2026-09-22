# Ragnarok Data Converter

![Swift 6.0](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift&logoColor=white)
![Platform macOS](https://img.shields.io/badge/Platform-macOS-000000)
![License GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)

Convert Ragnarok Online client resource files into normalized JSON datasets.

## Requirements

- macOS with a Swift 6-compatible toolchain

## Usage

### Convert

```bash
swift run ragnarok-data-converter convert <input> <output>
```

`convert` is the default subcommand, so it may be omitted.

- `input`: directory containing one subdirectory per Ragnarok Online client (see below)
- `output`: directory where JSON files will be written

### Fetch monster names

Clients that don't ship monster names get them as a `mobname.txt` scraped from [divine-pride.net](https://www.divine-pride.net/database/monster):

```bash
swift run ragnarok-data-converter fetch-mobname --region bRO Input
```

- `--region`: server as named in the divine-pride server selector; each maps to one client directory (`bRO` → `Brazil`, `cRO` → `China`, `twRO` → `Taiwan`, `LATAM` → `LatinAmerica`, …; see `FetchMonsterName.swift`)
- `input`: the same directory `convert` reads; the file is written to `<input>/<client>/mobname.txt`

The file has one `id,name` line per monster. divine-pride's list skips clones that share a name with another monster (e.g. 1220 next to 1106 "Desert Wolf"), so the command also pulls [rAthena's `mob_db.yml`](https://github.com/arkadeleon/swift-rathena/blob/master/db/re/mob_db.yml) and gives such monsters the translation of the other monster with the same English name. Monsters that still have no name are omitted.

## Input

Each client is kept as it ships, under a directory named after the region it serves. Which files are read for which locale is spelled out per client in `Convert.swift`.

```text
Input/
  Korea/          data/ System/ mobname.txt      → ko
  International/  data/ System/                  → en
  Japan/          data/ System/ mobname.txt      → ja
  China/          data/ System/ mobname.txt      → zh-Hans
  Taiwan/         data/ System/ mobname.txt      → zh-Hant
  Brazil/         data/ System/ mobname.txt      → pt-BR
  Thailand/       data/ System/                  → th
  Indonesia/      data/ System/                  → id
  Russia/         data/ System/ mobname.txt      → ru
  Europe/         data/{german,french,turkish}/ …
                  data/luafiles514/{german,…}/lua files/ …
                                                 → de, fr, tr
  LatinAmerica/   System/spanish/ …
                  data/spanish/LuaFiles514/lua files/ …
                  data/MsgStringTable_ml.csv     → es
```

Single-language clients keep everything in `data/` and `System/`. The euRO and latam clients ship one subdirectory per language with only the translated files, and fall back to the root of `data/` for the rest.

No client ships a `mobname.txt`; it is added by hand. The Chinese ones (`China/`, `Taiwan/`) come from [Pandas](https://github.com/PandasWS/Pandas.git), the others are scraped from [divine-pride.net](https://www.divine-pride.net) with `fetch-mobname` (see above).

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

`de`, `en`, `es`, `fr`, `id`, `ja`, `ko`, `pt-BR`, `ru`, `th`, `tr`, `zh-Hans`, `zh-Hant`

## License

This project is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for details.

## Asset Copyright

The Ragnarok Online resource files in `Input/` are copyrighted by Gravity Co., Ltd.
Use and redistribution of game assets should follow the rights granted by their respective owners.
