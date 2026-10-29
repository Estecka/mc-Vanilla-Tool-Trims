# STK's Tool Trims

A collection of trims for various tool.

Most assets are script-generated, and not under version control. After build, the repo itself can serve as both the datapack and the texturepack.
Run `build.sh` to run all build steps.

## Configurations
### config/sprites.txt
The list of trim sprites for each pattern. Each line formatted as:  
`<x> <y> <width> <height> <model> <tool_type>`

Instead of individual item textures, the sources contains a spritesheet for each trim pattern, only because it is more convenient for painting. Individual textures are sliced from that sheet during build.

- `x`, `y`: The position of the slice on the sheet.
- `width`, `height`: The dimensions of the slice.
- `model`: The parent that will be used for the corresponding baked model.
- `tool_type`: The family of tools the texture applies to, including the submodel suffix if applicable. (E.g: `spear_in_hand`)

### config/patterns.txt
The list of possible trim patterns, each line formatted as:  
`<pattern> <template>`
- `pattern`: The word  used in the "trim" component of the item.
- `template`: The item used as ingredient in the smithing table.
  (Only relevant to MC 1.21.4 and prior, where custom smithing recipes need to be generated.)

### config/materials.txt
The list of possible trim materials, each line formatted as:  
`<material> <material_item>`
- `material`: The word used in the "trim" item components of the item. (Eg: `copper`)
- `material_item`: The item used as ingredient in the smithing table. (E.g: `copper_ingot`)

### config/palettes.txt
The list of colour palettes that can be applied to each trim textures, each line formatted as:  
`<color> <palette>`
- `palette`: The the texture containing the actual palette.
- `color`: The word used in texture and model names that will use that palette.

Unlike the materials list, the palette list include `_darker` colors of some materials, used on same-material tools.

### config/models.txt
The list of models available to each family of tools. Each line formatted as:  
`<tool_type> <override>	<model_parent> [<texture_override>]`

This is used to generate copies of the vanilla models, with z-fighting fixed.

- `tool_type`: The family of tools this submodel applies to. (E.g: `sword`)
- `override`: The suffix of one submodel for the tool (e.g: `_in_hand`), or `--` for the base model.
- `model_parent`: The parent to use for this submodel (e.g: `handheld`). This refers to `estecka:display/<model_parent>` rather than the vanilla models.
- `texture_override`: The suffix of the texture used in this submodel, if different from `<override>`.


### config/tools.txt
The list of items that can receive trims, each line formatted as:  
`<tool_item> <tier> <tool_type> <states> [<overrides>]`
- `tool_item`: The full name of the tool. (Eg: `diamond_sword`)
- `tool_type`: The family of trim textures used by the tool. (E.g: `sword`)
- `tier`: The material the tool is made of. Tools with a same-material trims will use a `_darker` version of the colour palette for that material. Inside JSON templates, use the variable `${color}` instead of `${material}` to get the name of the actual palette used.
Tools that don't have a in-game tier still require a tier to be defined in that file; anything will do.
- `states`: The name of the JSON template for the corresponding item-state, located at `templates/item_state/<states>.json`. (Only relevant to MC 1.21.4 and later)
- `overrides`: An optional list of suffixes for additional baked model used by this tool. (Only relevant to MC 1.21.3 and prior)
