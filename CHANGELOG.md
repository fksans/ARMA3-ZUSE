# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.2.1]

### Changed

- English is now the default UI language; Simplified Chinese is still used when the game language is Chinese.
- Licensed under APL-SA.

## [1.2.0]

### Added

- A-B loop: loop a segment of a track for the selected listeners. The A / B buttons store the current playback position.

## [1.1.0]

### Added

- Playback targets: all players, a side, a squad, a single player, or the units selected in Zeus (or their squads).
- "I listen too" option for the Zeus.

### Changed

- "Play for all" / "Stop for all" buttons renamed to "Play" / "Stop".

## [1.0.1]

### Fixed

- Music is now broadcast through ZEN's event channel, so servers that block `remoteExec` of `playMusic` / `fadeMusic` no longer stop it. The old `remoteExec` method is still available in the addon options.

## [1.0.0]

### Added

- First release: music library from all loaded `CfgMusic`, favorites with groups and notes, preview, play / stop / fade for all players, now-playing display, CfgRemoteExec self-check, ZEN module, ZEN context menu entry and CBA keybind.
