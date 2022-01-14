# Xenia Game Patches
This repository contains game patches for Xenia.

## Installing

### All patches
1. Download the <!--[zip](https://github.com/xenia-canary/game-patches/archive/main.zip)--> zip file.
2. Extract the patches folder where `xenia.exe` is located:
<!--<br>![](https://raw.githubusercontent.com/xenia-canary/game-patches/main/images/patches.png)-->
3. Continue to [enabling patches](#enabling-patches).

### Individual patch(es)
1. Open the patch file on GitHub.
2. Right click `Raw`, and click `Save Page As`.
3. Place the file into the `patches` folder.
4. Continue to [enabling patches](#enabling-patches).

#### Enabling patches
To enable patches, open the .patch file that corresponds to your game in a text editor (Notepad, Notepad++, VSCode, etc.), and change `is_enabled` from `false` to `true`.

#
### Contributing
 * When submitting a patch, make sure to create a Pull Request for a file to be added to the `patches` folder in the repository.
 * If the game you are submitting a patch for already has a .patch file, then create a Pull Request to edit that file and add your name as an author.
 * This new file must be named `[Title ID] - Game Title.patch`
 <br>For example, a patch file for Halo 3 must be called `4D5307E6 - Halo 3.patch`.
 * File must contain the executable hash, which can be obtained [here](#Obtaining-XEX-hash).
 * File must contain an empty line at the end.

Example of the contents that should be included in the file:
<details><summary>Example (click to expand)</summary>

```
title_name = "Blue Dragon"
title_id = "4D5307DF"

[[patch]]
    name = "Enable Wireframe"
    desc = "Significantly impacts performance. Useful for viewing aspects of levels."
    author = "illusion"
    is_enabled = false

    [[patch.be32]]
        address = 0x82132D68
        value = 0x39600001

[[patch]]
    name = "Enable Camera Bounding Box"
    author = "illusion"
    is_enabled = false

    [[patch.be32]]
        address = 0x821340B0
        value = 0x39600001

[[patch]]
    name = "60 FPS (WIP)"
    desc = "Work-in-progress, can be improved upon by others. Causes softlocks in battles."
    author = "illusion"
    is_enabled = false

    [[patch.be32]]
        address = 0x820ce6bc # Will need to find a way to write 3f00 rather than nop.
        value = 0x60000000
    [[patch.be32]]
        address = 0x821a0640
        value = 0x60000000
    [[patch.be32]]
        address = 0x8273664c
        value = 0x60000000
    [[patch.be16]]
        address = 0x82DEC57C # Game speed
        value = 0x3f00
    [[patch.be16]]
        address = 0x82DDA880 # Battle speed; disabling this avoids softlocks, but doubles speed.
        value = 0x3f00
    [[patch.be32]]
        address = 0x8246ab68 # Vsync flip rate
        value = 0x39400001
```
</details>

### For Developers
Memory Breakpoints can be set in Cheat Engine or MSVC with `emit_source_annotations`.

This will show an xex address when a breakpoint is hit, although there is currently no way to set a breakpoint on execution within the Xenia Debugger.

Xex loader plugins for reverse engineering tools:
  * [Ghidra XEX Loader](https://github.com/zeroKilo/XEXLoaderWV/releases)
  * [IDA 7 XEX Loader](https://github.com/emoose/idaxex)
  * [IDA 6 XEX Loader](https://xorloser.com/blog/?p=395)

### Obtaining XEX hash
1. Run the executable once.
2. Close Xenia.
3. Open `xenia.log`.
4. Search (<kbd>Ctrl+F</kbd>) for `Module hash:`
<br>You should see something like:
<br>`Module hash: 0000000000000000 for (xex name)`
