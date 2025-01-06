# STK's Tool Trims

A collection of trims for various tool.
The datapack is powered only by custom smithing recipes, and item models.

Most assets are script-generated, and not under version control. After build, the repo itself can serve as both the datapack and the texturepack.
Run `build.sh` to automatically run all build steps.

## Spritesheets
Instead of individual item textures, the sources contains a spritesheet for each trim pattern, only because I find it more convenient for painting.

The actual texture are sliced from those sheets using `sh/make-textures.sh`. The list of texture to be generated from each spritesheet is defined in `spritesheets/slices.txt`, each line formatted as:  
`<tool_type> <x> <y> <width> <height>`

## Source Data

The list of patterns is inferred from the list textures generated from the spritesheets.
Other data is sourced from the files in `ingredients/`

### ingredients/materials.txt
The list of possible trim material, each line formatted as:  
`<material> <material_item>`
- `material` is the word used in the "trim" item components of the item. (Eg: `copper`)
- `material_item` is the item used as ingredient in the smithing table. (E.g: `copper_ingot`)


### ingredients/tools.txt
The list of possible tools, each formatted as:  
`<tool_type> <tier> <tool_item>`
- `tool_item` is the full name of the tool. (Eg: `diamond_sword`)
- `tool_type` is the family of trim textures used by the tool. (E.g: `sword`)
- `tier` is the material of the tool. Tools with a same-material trims will use a `_darker` version of the colour palette for that material. In templates, use the variable `<color>` instead of `<material>` to get the name of the actual palette used.
Tools that don't have a in-game tier still require a tier to be defined in that file; whatever value will do.

### ingredients/palettes.txt
The list of colour palettes that can be applied to each trim textures, each line formatted as:  
`<color>`

Unlike the materials list, this includes `_darker` versions of some materials, used by same-material tools.
This list should match the one listed in `templates/atlas.json`

## Templates and build scripts
Each file in `templates/` is used by a specific build script to generate a specific series of assets. Those templates can contain shell variables that will be substitued with values from the source data listed above.

Not all templates and scripts are relevant to all versions of minecraft.

### Atlas
- `make-atlas` + `atlas.json`: Populates `assets/minecraft/atlases/block.json`, whith the list of available trim textures. This is used by minecraft itself to coloured versions of the trims.

### Item models (1.21.4)
- `make-trim-models` + `model_trim.json`: Creates baked models containing **only** the trim, without the tool: `assets/minecraft/models/trims/items/<tool_type>/<pattern>.png`. They are combined with the vanilla tool models using the "composite" model selector in item states.
This is a bit different from how vanilla handles trimmed armour models, but I believe doing it this way is beneficial, because this considerably reduces the amount of baked models that need to be loaded by the game.

- `make-item-states` + `item_state.json`: Creates item states for every tool-x-pattern combination: `assets/minecraft/items/<tool_item>/<pattern>.json`
Those item-states are populated with the available materials and the appropriate palette color for the tool's tier.

### Item models (1.21.3 and prior)
- `make-item-models` + `model-item.json`: Creates fully baked models for every tool-x-pattern-x-palette combination: `assets/minecraft/models/item/<tool_type>/<pattern>_<color>.png`.

### Recipes
- `make-recipes`: `data/minecraft/recipes/<tool_item>/<pattern>_<material>.json`  
Creates a recipe for every possible trim combination. Individual recipes are required in order to set the correct item model component on the tool. This is only relevant to MC 1.21.2 and onward, when support for vanilla clients is required.

- `make-tag`: Populates the tag `data/minecraft/tags/items/trimmable.json`
This is only relevant to "stateless" versions of the data-pack, that rely on clients using the mod Variants-CIT. In particular: MC 1.21.1 and prior, which do not have item model components.
