# Xenia Game Patches
This repository contains game patches for Xenia.

## Installing

### All patches
1. Download the <!--[zip](https://github.com/xenia-canary/game-patches/archive/main.zip)--> zip file.
2. Extract the patches folder where `xenia.exe` is located.
3. Continue to [enabling patches](#enabling-patches).

### Individual patch(es)
1. Open the patch file on GitHub.
2. Right click `Raw`, and click `Save Page As`.
3. Place the file into the `patches` folder.
4. Continue to [enabling patches](#enabling-patches).

#### Enabling patches
To enable patches, open the .patch file that corresponds to your game in a text editor (Notepad, Notepad++, VSCode, etc.), and change `is_enabled` from `false` to `true`.

---

### Contributing
 * When submitting a patch, make sure to create a Pull Request for a file to be added to the `patches` folder in the repository.
 * If the game you are submitting a patch for already has a .patch file, then create a Pull Request to edit that file and add your name as an author.
 * This new file must be named `[Title ID] - Game Title.patch`
<br>For example, a patch file for Halo 3 must be called `4D5307E6 - Halo 3.patch`.
 * File must contain the executable hash, which can be [automatically](#creating-patch-file) or [manually](#obtaining-xex-hash) obtained (Log Level must be set to 2 or above).
 * File must contain an empty line at the end.

Example of the contents that should be included in the file:
<details><summary>Example (click to expand)</summary>

```toml
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
        address = 0x820CE6BC # Will need to find a way to write 3F00 rather than nop.
        value = 0x60000000
    [[patch.be32]]
        address = 0x821A0640
        value = 0x60000000
    [[patch.be32]]
        address = 0x8273664C
        value = 0x60000000
    [[patch.be16]]
        address = 0x82DEC57C # Game speed
        value = 0x3F00
    [[patch.be16]]
        address = 0x82DDA880 # Battle speed; disabling this avoids softlocks, but doubles speed.
        value = 0x3F00
    [[patch.be32]]
        address = 0x8246AB68 # Vsync flip rate
        value = 0x39400001
```

</details>

### Developer requirements
* [Cheat Engine](https://www.cheatengine.org)
* [Ghidra](https://ghidra-sre.org/)
    * [Ghidra XEX Loader](https://github.com/zeroKilo/XEXLoaderWV/releases)
* [IDA Pro](https://hex-rays.com/ida-pro/)
    * [IDA 7 XEX Loader](https://github.com/emoose/idaxex)
    * [IDA 6 XEX Loader](https://xorloser.com/blog/?p=395)

### Setting up Cheat Engine
Memory Breakpoints can be set in Cheat Engine or MSVC with `emit_source_annotations`. This will give annotations in disassembly.
 * Cheat Engine 7.2+ includes Big Endian types, but they must be enabled;
     * Click `Edit` > `Options` > `Extra Custom Types` and check all of them.
 * Also go to `Scan Settings` and enable `MEM_MAPPED`.

To search the emulator memory, change 'Memory Scan Options' to:
  |     | All
  ----- | :----------
  Start | `100000000`
  Stop  | `200000000`
 * This may change depending on the programs you have running.
 * Once you find a value you can attach Cheat Engine's debugger to see what reads/writes to that address.
<br>This will show an xex address when a breakpoint is hit, although there is currently no way to set a breakpoint on execution within the Xenia Debugger.

### Creating patch file
0. Prerequisites:
    * [Xenia Patch Maker](https://github.com/oSerenity/Xenia-Patch-Maker)
1. Run the game once.
2. Close Xenia.
3. Locate `xenia.log`.
4. Drag and drop `xenia.log` into Xenia Patch Maker.
    * Xenia Patch Maker will load the game's info.
    * Proceed to make your patch file.

### Obtaining XEX hash
1. Run the executable once with Xenia.
2. Close Xenia.
3. Open `xenia.log`.
4. Search <kbd>Ctrl+F</kbd> for `Module hash:`
<br>You should see something like:
<br>`Module hash: 0000000000000000 for default`
