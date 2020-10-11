TODO: write instructions on how to install patches

### Gears of War
<details><summary>Patches (Click to Expand)</summary>

```
title_name = "Gears Of War"
title_id = "4D5307D5"

[[patch]]
	name = "GoW - Texture rendering"
	desc = "None"
	author = "Gliniak"
	is_enabled = true
	
	[[patch.be32]]
		address = 0x822306D8
		value = 0x409AFF6C
```
</details>

#
### Gears Of War 2
<details><summary>Patches (Click to Expand)</summary>

```
title_name = "Gears of Wars 2"
title_id = "4D53082D"
#media_id = "22AB4F7C"

[[patch]]
    name = "Unlock FPS"
    desc = "Removes FPS Cap. Users will need to set vsync to false in Xenia Options to go above 60FPS."
    author = "illusion"
    is_enabled = true

# vsync limit // doesn't work above 60hz if not using param
    [[patch.be32]]
        address = 0x8298CF70
        value = 0x39600000

    [[patch.be32]]
        address = 0x824A2E94
        value = 0x60000000

[[patch]]
    name = "Disable Ambient Occlusion"
    desc = "None"
    author = "illusion"
    is_enabled = false

    [[patch.be32]]
        address = 0x826F9D18
        value = 0x39600000

[[patch]]
    name = "Disable Motion Blur"
    desc = "None"
    author = "illusion"
    is_enabled = true

    [[patch.be32]]
        address = 0x8236004C
        value = 0x39600000
```
</details>

#
### Rockstar Table Tennis
<details><summary>Patches (Click to Expand)</summary>

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

#
### Mirror's Edge
<details><summary>Patches (Click to Expand)</summary>

```
title_name = "Mirror's Edge"
title_id = "45410850"
#media_id = "426CA5A2"

[[patch]]
    name = "FPS Unlock"
    desc = "Removes FPS Cap. Users will need to set vsync to false in Xenia Options to go above 60FPS."
    author = "illusion"
    is_enabled = true
# vsync limit // doesn't work above 60hz if not using param
    [[patch.be32]]
        address = 0x828148e8
        value = 0x39600000
# 62 fps limit
    [[patch.be32]]
        address = 0x8254f5fc
        value = 0x60000000
```
</details>
