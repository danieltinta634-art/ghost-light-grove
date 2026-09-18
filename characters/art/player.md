---
name: The Player
art_done: false
---
# The Player — Art & Assets
*(Reference only. ✅ system confirmed 2026-09-18; specific option counts still open.)*

**System (✅ confirmed): layered/modular, not baked-per-combo.**
This is a hard departure from every NPC art file in this project — NPCs
bake their equipped tool into a full per-tool frame set on one sprite
sheet, which works because each NPC has exactly one fixed appearance. The
player doesn't, so baking is off the table combinatorially (skin tones ×
hairstyles × outfits × tools × 4 directions × 4 walk-cycle frames would
multiply out of control). Instead:

- **Base body layer** — two body types (tied to gender selection at
  character creation), multiple skin tones. This is the only layer that
  changes per-frame for walking/animation; everything else rides on top
  of it in the same pose.
- **Hair layer** — swappable, drawn to align with the base body's head
  position across all 4 directions × 4 walk-cycle frames.
- **Outfit layer** — swappable, same alignment requirement.
- **Tool/weapon layer** — equipped tool renders as its own layer positioned
  relative to the base body's hand per frame (the "separate overlay
  layer" approach the NPC-tool decision explicitly rejected for NPCs, but
  the only workable one here).

Each layer is authored once per option (one hairstyle = one small sheet
usable on both body types and all outfits) rather than once per
combination — this is what makes "full Stardew-scale" customization
actually affordable.

**Sizes:** same base grid as NPCs — overworld sprite 16×32, portrait
64×64, 4 directions × 4 walk-cycle frames. Each layer sheet matches these
dimensions/frame counts exactly so they composite in alignment.

**Open:** exact number of skin tones / hairstyles / starting outfits ·
whether portraits also composite from layers or get authored as fixed
combinations (portraits change less often than the overworld sprite, so
baking per-combo may be affordable there even though it isn't for the
walk cycle) · art style consistency with the NPC style-anchor (the player
should read as clearly "from" the same world as the townsfolk, not a
mismatched import).
