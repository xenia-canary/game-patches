# Xenia Canary Game Patches
This repository contains game patches for Xenia Canary.

[![Game Patches Discord](https://img.shields.io/discord/930763773109735484?color=5865F2&label=Game%20Patches%20Discord&logo=discord&logoColor=white)](https://discord.gg/fyRWq3xYNz)

## Installing/Updating

### All patches
1. Delete `patches` folder if present.
2. Download the [zip](../../../archive/main.zip) file.
3. Extract the patches folder to the proper location:
    |                            | Location
    --                           | --------
    Default                      | `Documents\xenia`
    portable.txt (Portable mode) | Same directory as `xenia.exe`
4. Continue to [enabling patches](#Enabling-patches).

### Individual patch(es)
1. Open the patch file on GitHub.
2. Right click `Raw`, and click `Save Page As`.
3. Place the file into the `patches` folder.
4. Continue to [enabling patches](#Enabling-patches).

#### Enabling patches
**`apply_patches` must be set to `true` in the Xenia Canary config!**

To enable patches, open the .patch.toml file that corresponds to your game in a text editor (Notepad, [VSCode](https://code.visualstudio.com/), [VSCodium](https://vscodium.com/), [Notepad++](https://notepad-plus-plus.org/), etc.), and change `is_enabled` from `false` to `true`.

#
#### Note about aspect ratio patches
**`present_letterbox` must be changed from `true` to `false`!**

These patches **do not** increase resolution!

While most aspect ratio patches are 21:9 (3440/1440), they can be changed to other aspect ratios as well;

1. Divide your monitor's resolution width by height (i.e. 3440/1440)
2. [Convert the result to hex](https://gregstoll.com/~gregstoll/floattohex).
3. Change the value to `0x########` replacing `########` with the hex value.

## Troubleshooting
If the above sections didn't help, you can try the following:
1. Make sure you followed [Enabling patches](#Enabling-patches).
2. Try deleting all of your patches and [updating them](#Updating).
3. Try commenting out the `hash` of the patch like so:
    ```toml
    # Add # before hash
    hash = "################"
    # like this
    #hash = "################"
    ```
    **This isn't guaranteed to work, and may cause crashes.**
    <br>Hashes are used to verify the correct version of a game is being patched, and this bypasses it.

---

## Contributing

### Prerequisites
* [Cheat Engine](https://www.cheatengine.org)
  * Memory Breakpoints can be set in Cheat Engine or MSVC with [`emit_source_annotations = true`](https://github.com/xenia-canary/xenia-canary/wiki/Options). This will give annotations in disassembly.
    * Cheat Engine 7.2+ includes Big Endian types, but they must be enabled;
        * Click `Edit` > `Options` > `Extra Custom Types` and check all of them.
    * Go to `Scan Settings` and enable `MEM_MAPPED`.
    * Change 'Memory Scan Options' to:
      |     | All
      ----- | :----------
      Start | `100000000`
      Stop  | `200000000`
      * This may change depending on the programs you have running.
      * Once you find a value you can attach Cheat Engine's debugger to see what reads/writes to that address.
    <br>This will show an xex address when a breakpoint is hit, although there is currently no way to set a breakpoint on execution within the Xenia Debugger.
* [Ghidra](https://ghidra-sre.org/)
    * [Ghidra XEX Loader](https://github.com/zeroKilo/XEXLoaderWV/releases)
* [IDA Pro](https://hex-rays.com/ida-pro/)
    * [IDA 7 XEX Loader](https://github.com/emoose/idaxex)
    * [IDA 6 XEX Loader](https://xorloser.com/blog/?p=395)
* Text editors:
  * [Visual Studio Code](https://code.visualstudio.com/)
  * [VSCodium](https://vscodium.com/)
  * [Notepad++](https://notepad-plus-plus.org/)
* Recommended but optional:
  * [ESLint TOML plugin](https://ota-meshi.github.io/eslint-plugin-toml/user-guide/#installation)
      * See [Editor Integrations](https://ota-meshi.github.io/eslint-plugin-toml/user-guide/#editor-integrations)
  * Visual Studio Code/VSCodium extensions:
      * [Even Better TOML](https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml)

### Creating patch
0. To make things easier, it's recommended to put Xenia Canary in the directory that contains `/patches` and run it with [`portable.txt`](https://github.com/xenia-project/xenia/wiki/Options#how-to-use).
* File name must be `Title ID - Game Title.patch.toml` and be in `/patches`.
 <br>For example, a patch file for Blue Dragon must be called `4D5307DF - Blue Dragon.patch.toml`.
  * If the game you are submitting a patch for already has a file, then add to that file.
* Example patch:
  ```toml
  title_name = "Game Title"
  title_id = "1234ABCD" # AB-1234
  hash = "" # Module that the hash applies to (i.e. default.xex)
            # Can be an array if applicable:
  hash = [
    #""     # See above
  ]
  #media_id = "1234ABCD" # Optionally you can add a redump link; Disc (Region): http://redump.org/disc/1234
  #                        Can also be an array if applicable:
  #media_id = [
  #  "1234ABCD"          # See above
  #]

  [[patch]]
    name = "Patch name"
    author = "Me"
    desc = "Patch description" # Description is optional
    is_enabled = false         # Must be false for PRs

  # [[patch.(type)]]
  #   Type can be the following:
  #     be8:       1 byte;                 0x00
  #     be16:      2 bytes;                0x0000
  #     be32:      4 bytes;                0x00000000
  #     be64:      8 bytes;                0x0000000000000000
  #     array:     TODO;
  #     f32:       4 byte float (single?); 1.0
  #     f64:       8 byte float (double?); 1.0
  #     string:    TODO;
  #     u16string: TODO;
  #   For example, be8:
    [[patch.be8]]
      address = 0x82000000 # Tends to start with 0x82, always 4 bytes
      value = 0xa0
  #  Address and value hex must be lowercase.
  #End of file newline
  ```
  * Module hash+filename can be obtained:
   * For games with multiple executables or discs, it can have multiple hashes, but they must be commented out like so:
     https://github.com/xenia-canary/game-patches/blob/95f51801048dc6e95675581e3fcf8fcdfc3e5544/patches/454108D8%20-%20Army%20of%20Two%20The%2040th%20Day.patch.toml#L3-L6
    1. Set [`log_level`](https://github.com/xenia-canary/xenia-canary/wiki/Options) to at least [`2` (default)](https://github.com/xenia-canary/xenia-canary/wiki/Options) in the Xenia Canary config; See [How to use](https://github.com/xenia-canary/xenia-canary/wiki/Options#how-to-use) for location.
    2. Run the game at least once.
    3. Close Xenia.
    4. Obtain module hash/title ID/title name;
        * Search <kbd>Ctrl+F</kbd> for `Module hash:` in `xenia.log`
        <br>You should see something like:
          ```
          i> ######## Module \Device\Cdrom0\default.xex:
          Module Hash: ################
          ```
