# Tile Catalog — Ghost Light Grove tilesets

> Tile id = row*40 + col (Overworld, 40 cols). In a map, gid = firstgid + id.
> Built by visual inspection to enable proper autotiling & map-building.

## OVERWORLD (zelda/gfx/Overworld.png — 40×36 = 1440 tiles)

### Terrain region (cols 0–9, rows 0–9) — CATALOGED

**Grass:**
- **Plain grass fill:** id 0 (0,0). Other plain grass: 120,122,160,162,200,201,242,243,244,245,360,361,364–369. (Use a verified-seamless one as the fill; test before bulk use.)
- **LIGHT-GRASS PATCH set** (lighter grass for organic variation — THIS is how you "blend" grass, not random fill-swapping): ids 121,161,240,241,280,281 (a lighter-green blob autotile — place as patches inside the base grass for Stardew-style variation).
- **Grass with flowers:** 320,321 (white flower specks on grass — sparse accent).

**Water:**
- **Water + grass shoreline (top edge, wavy):** 40,41,42,43 / 80,81,82,83 (rows 1–2, cols 0–3) — the water-meets-grass autotile edges.
- **Water-grass corner pieces (rounded):** 0-row corners at (0,0)-area and (2,0),(3,0)… the rounded water/grass blobs at row 0 cols 2–5 region.
- **Deep water fill (rippled):** 123,124,125 / 163,164,165 (the pond interior).
- **Small pond w/ sandy white border:** 283,284 / 323,324 / 362,363 (a separate water-edge style with pale border).

**Objects (place on Buildings/Front layers):**
- Tree stump: id 1
- Lily pads (water plants): 2,3,4,5
- Boulders/rocks: 84,85 ; 207,208,209 ; small rocks 45
- Log (3 tiles): 203,204,205
- Wooden signs/fence boards: 247,287,327 (a post column) ; 246,286,326 & 249,289,329 (fence sections)

**Building (a house):** cols 7–9, rows 0–4 — roof (7,8,9 / 47,48,49), walls + window + door (87,88,89 / 127,128,129 / 167,168,169). Multi-tile structure.

### KEY INSIGHT for grass "blending"
The right technique here = **base grass fill + organic patches of the LIGHT-GRASS set (121,161,240,241,280,281)**, like Stardew's lighter grass areas — NOT random-swapping fill tiles (which caused the dark-corner grid). Plus very sparse flower accents (320,321).

### TODO — still to catalog
- Overworld cols 10–39 (paths/dirt, more buildings, fences, fountains, market, statues, walls, gates, flags)
- Overworld rows 10–35
- rpg16 grass_cliff (cliff edges/corners/faces/stairs)
- rpg16 other sheets (waterfall, cave, dirt, plants, buildings, roofs)
