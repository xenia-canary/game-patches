# Xenia Canary Game Plugins
This page documents the usage of plugins for [Xenia Canary](../../../../xenia-canary). For patches visit [Game Patches](https://github.com/xenia-canary/game-patches#xenia-canary-game-patches).

## Plugins

Plugins are homebrew xex modules which can be used for making mods. This is an experimental feature since homebrew xex modules may use unimplemented low priority kernel functions. Plugins will often notify if they have been loaded.

Dual booting plugins is possible, however a lot of plugins are incompatible with each other and will often crash on start-up.

## Prerequisites
- [Latest Xenia Canary experimental.](https://github.com/xenia-canary/xenia-canary/releases/download/experimental/xenia_canary.zip)
    - Plugins aren't supported on master or outdated versions of Xenia Canary.

## Creating a Plugin config

1. Set `allow_plugins = true` in the config.
2. Create a plugins folder.
3. Create a folder named as the games title id, within the plugins folder.
4. Create a `plugins.toml` for the title.
5. Place the plugin(s) inside the title id folder.

If you see **[Plugins Applied]** in the title bar then the plugin(s) config loaded successfully.

## Example Plugin folder structure
```
└───Xenia Canary
    │   xenia-canary.config.toml
    │   xenia_canary.exe
    │   ...
    └───plugins
        ├───4D5308BC # Crackdown 2
        │       ...
        │       plugin.xex
        │       plugins.toml
        │
        └───545408A7 # GTA V
                ...
                plugin 1.xex
                plugin 2.xex
                plugins.toml
```

## Example Plugin Template
```toml
title_name = "Game Title"
title_id = "1234ABCD"

[[plugin]]
    name = "Plugin name"
    file = "Plugin file" # plugin.xex must be in the same directory as plugins.toml
    hash = "################" # Module the hash applies to (i.e. default.xex)
    desc = "Plugin description"
    is_enabled = false
```