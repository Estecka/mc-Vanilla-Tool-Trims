## Minecraft Changes
## 1.21.5
- First Vanilla-Stateless release of the pack.

## 1.21.9
- Added copper tools
- Added `copper_darker` color palette.

## 1.21.11
- Added Spears
- Added the `items` atlas.
  This is not a breaking change *yet*.
- Armor-item trims were moved from the `blocks` to the `items` atlas.

### 26.1
- Composite models aren't ordered properly if they mix textures from the `blocks` and `items` atlases.
  Tool trims **must** be moved to the `items` atlas

### 26.2
- The previous issue was fixed ???

## 26.3
- Color palettes were moved from `trim/color_palettes/` to `palettes/trim/`.
- Palette IDs now resolves against `textures/palettes/` instead of `textures/`.
- Key palette was renamed from `trim_palette` to `trim_base`.
