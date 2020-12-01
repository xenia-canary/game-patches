# Xenia Game Patches

This repository contains Game Patches available for the Xenia Emulator.

## Contributing

 - When submitting a game patch, make sure to create a Pull Request for a file to be added to the `patches` folder in the repository.

 - If the game you are submitting a patch for already has a .patch file, then create a Pull Request to edit that file instead of creating a new .patch file.

 - This new file must be named `[Title ID].patch` - For example, a patch file for Halo 3 must be called `4D5307E6.patch` (All uppercase)

- File must contain empty line at end of file.

Example of the contents that should be included in the file:
<details><summary>Example (Click to Expand)</summary>

```
title_name = "Rockstar Table Tennis"
title_id = "545407DF"

[[patch]]
    name = "Rockstar Table Tennis - Crash Skip"
    desc = "None"
    author = "Gliniak"
    is_enabled = true
    
    [[patch.be8]]
        address = 0x8237A3DB
        value = 0x05
```
</details>

### Installing

1. Download the [ZIP](https://github.com/xenia-canary/game-patches/archive/main.zip) file.

2. Extract the patches folder to where your Xenia Canary executable is located.

<details><summary>Image (Click to Expand)</summary>

![](https://cdn.discordapp.com/attachments/747164286056661153/764464248176115712/unknown.png)

</details>

3. To enable patches (if they're not already enabled by default), open the .patch file that corresponds to your game's ID with a text editor (Notepad, Notepad++, VSCode, etc.), and set `is_enabled` from `false` to `true`
