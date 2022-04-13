# Xenia Canary Game Patches
This repository contains game patches for Xenia Canary.

[![Game Patches Discord](https://img.shields.io/discord/930763773109735484?color=5865F2&label=Game%20Patches%20Discord&logo=discord&logoColor=white)](https://discord.gg/fyRWq3xYNz)

## Installing
Game patches are now included with Xenia Canary.
  * Xenia Canary must be set to portable. See [all patches](#All-patches)

### Updating
1. Delete `patches` folder.
2. Continue to [Installing all patches](#All-patches).

### All patches
1. Download the [zip](../../../archive/main.zip) file.
2. Extract the patches folder to the proper location:
    |                            | Location
    --                           | --------
    Default                      | `Documents\xenia`
    portable.txt (Portable mode) | Same directory as `xenia.exe`
3. Continue to [enabling patches](#Enabling-patches).

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
    <br>However, superficial differences (title/media ID, etc) can generate a different hash, even if the underlying code is the same.

---

## Contributing
 * When submitting a patch, create a Pull Request for a file to be added to `/patches`.
 * New file must be named `Title ID - Game Title.patch.toml`
  <br>For example, a patch file for Blue Dragon must be called `4D5307DF - Blue Dragon.patch.toml`.
 * If the game you are submitting a patch for already has a file, then add to that file.
 * New file must contain the module hash, which can be [automatically or manually](#Creating-patch) obtained.
    * For games with multiple executables or discs, it can have multiple hashes, but they must be commented out like so:
      https://github.com/xenia-canary/game-patches/blob/0ddf1f67d8843f30162a695c66084f6d8485397a/patches/4D5307DF%20-%20Blue%20Dragon.patch.toml#L1-L5
 * File must contain an empty line at the end.

### Prerequisites
* [Cheat Engine](https://www.cheatengine.org)
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

### Setting up Cheat Engine
Memory Breakpoints can be set in Cheat Engine or MSVC with [`emit_source_annotations = true`](https://github.com/xenia-canary/xenia-canary/wiki/Options). This will give annotations in disassembly.
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

### Creating patch
To make things easier, it's recommended to put Xenia Canary in the directory that contains `/patches` and run it with [`portable.txt`](https://github.com/xenia-project/xenia/wiki/Options#how-to-use).

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
