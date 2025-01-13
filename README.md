# STK's Tool Trims

A collection of trims for various tool.
The datapack is powered only by custom smithing recipes, and item models.

Most assets are script-generated, and not under version control. After build, the repo itself can serve as both the datapack and the texturepack.
Run `build.sh` to automatically run all build steps.

## Configurations
### spritesheets/slices.txt
Instead of individual item textures, the sources contains a spritesheet for each trim pattern, only because I find it more convenient for painting.

The actual texture are sliced from those sheets using `sh/make-textures.sh`. The list of texture to be generated from each spritesheet is defined in `spritesheets/slices.txt`, each line formatted as:  
`<x> <y> <width> <height> <model> <tool_type>`

- `x` and `y` are the position of the slice on the sheet.
- `w` and `h` are the dimensions of the slice.
- `model` is the parent that will be used for the corresponding baked model.
- `<tool_type>` is the family of tool the texture applies to, including modifier suffix if applicable. (E.g: `bow_pulling_1`)


### ingredients/materials.txt
The list of possible trim materials, each line formatted as:  
`<material> <material_item>`
- `material` is the word used in the "trim" item components of the item. (Eg: `copper`)
- `material_item` is the item used as ingredient in the smithing table. (E.g: `copper_ingot`)

### ingredients/patterns.txt
The list of possible trim patterns, each line formatted as:  
`<pattern> <template>`
- `template` is the item used as ingredient in the smithing table.
- `pattern` is the word  used in the "trim" component of the item.


### ingredients/tools.txt
The list tools that can receive trims, each line formatted as:  
`<tool_item> <tier> <tool_type> <model> <overrides>`
- `tool_item` is the full name of the tool. (Eg: `diamond_sword`)
- `tool_type` is the family of trim textures used by the tool. (E.g: `sword`)
- `tier` is the material of the tool. Tools with a same-material trims will use a `_darker` version of the colour palette for that material. In templates, use the variable `<color>` instead of `<material>` to get the name of the actual palette used.
Tools that don't have a in-game tier still require a tier to be defined in that file; whatever value will do.
- `model` is the name of JSON template for the corresponding item state, located at `templates/item_state/<model>.json`. (Only relevant to MC 1.21.4 and later)
- `overrides` is an optional list of suffixes for additional baked model used by this tool. (Only relevant to MC 1.21.3 and prior)

### ingredients/palettes.txt
The list of colour palettes that can be applied to each trim textures, each line formatted as:  
`<color> <palette>`
- `palette` is the the texture containing the actual palette.
- `color` is the word used in texture and model names that will use that palette.

Unlike the materials list, colors include `_darker` versions of some materials, used by same-material tools.
