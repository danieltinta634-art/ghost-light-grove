# GHOST LIGHT GROVE — Design Doc v2.0

> Consolidates Design Bible v1.0 (Canva) + all decisions from design sessions 2026-06-11 → 2026-06-13.
> Story spoilers live in `story-spoiler-doc.md` — this doc stays spoiler-light.
> Anything marked **(proposed)** is Claude's suggestion awaiting designer approval. Everything else is designer canon.

---

## Elevator Pitch

A cozy supernatural farming and life sim. The player inherits a haunted manor in a hidden town of monsters that lives in perpetual night — and discovers the inheritance is more than a house. Farming, found family, romance, exploration, and a mystery fed to the player one moonlit night at a time.

**Tone:** whimsical, cozy, funny, occasionally melancholic — never truly frightening. *(Test: Beetlejuice, not Babadook.)*

**Pillars:** Cozy Community · Farming & Homesteading · Exploration · Supernatural Mystery · Found Family.

---

## World Rules

- **Perpetual night, local.** The Grove is a veiled region of the mainland; inside, the sun never rises. Outside, the ordinary daylit world carries on, unaware.
- **The Grove draws those who need it.** Outcast supernatural folk feel a pull toward it. Arrival stories = need stories.
- **The moon is the clock.** It arcs over the manor each night; players read time from its position against the manor silhouette. Phases change nightly; a **Full Moon closes every week**.
- **Ghost light** is spirit energy — what "light" fundamentally is here. (Full lore: spoiler doc.)

## Calendar & Time

- **7-night weeks.** Moon phase changes nightly; Full Moon is the weekly event night.
- **Four tides × 4 weeks = a 112-night year.** Tides are supernatural seasons: each changes the crop list, world palette/weather, fish & forage tables, one major festival, Deep Woods behavior, and available story beats.
  - Tide names/flavors **(proposed)**: Harvest-tide (golden, abundant, onboarding) → Mist-tide (fog, mushrooms, spirits, fishing) → Frost-tide (harsh, indoor/social) → Ghost-tide (veil thins, phase-locked crops, mystery beats, year-end festival).
- **A night ≈ 15 real minutes**, dusk to dawn, Stardew-standard pacing.
- **Stamina bar**: tools drain it, food restores it (keeps Hazel's cooking relevant forever).
- **Day = timeskip, but the world shifts while you sleep.** A **dusk report** (replacing Stardew's morning summary) tells what changed: crops grew, fog moved, Jack is facing the house now.

## Economy

- **Glimmers** — the everyday currency of the town: crops, shops, services.
- **Ghost light** — a **refinable material resource** (like ore / Stardew's iridium), NOT experience/XP (the old moonstone idea is CUT). Flow: reap spirits → pass them on at the well → receive **raw ghost light** → **refine it** (at a refining station — location OPEN) → **refined ghost light** is the building/crafting/upgrade resource. Stockpiled physically, like any farm resource.
- **Refined ghost light upgrades ALL gear** (designer canon): the **scythe** (reaper capacity/abilities), the **melee weapon** (Deep Woods combat), and **farm tools** (hoe, watering can, axe, etc.). This is the single material that makes everything you carry better — closes the earlier "scythe upgrade source" and "weapon upgrade path" questions.
- **Ghost light is also spent on:** manor restoration power, Victor's tech upgrades, and town lamps/infrastructure.
- One open ripple from cutting moonstones: Full Moons lost their economic specialness — **(proposed)** spirits surge on Full Moon nights so reaping (ghost light income) spikes, keeping the weekly climax materially rewarding.
- Vendor map: **Lionel's general store** (seeds/staples — see below) · Briar = building/construction · Myra = livestock & ranch supplies · Hazel = food/potions · Victor = tech/equipment upgrades · Alastair's museum = collection content, not commerce.

### Lionel's General Store
The town's everyday shop — the Pierre's-of-Pelican-Town slot. **Pure general store; Lionel's archaeology is flavor/voice only, not a mechanic** (he narrates the price of turnip seeds like a tomb inscription). Sells:
- **Seeds** (the core farming supply, rotating by tide)
- **Basic tools, supplies, fertilizer, fences, crafting staples**
- **Backpack / inventory upgrades** (classic general-store progression)
- **A sell box** for offloading crops & goods for glimmers
Kept deliberately distinct from Alastair's museum (cursed artifacts, donated not sold) and Alice's library (lore/research) — Lionel just runs the shop, magnificently.

## Core Loops

1. **Farm** — crops keyed to tides and moon phases; signature crops need both (e.g. a flower that only sprouts if planted on a New Moon during a specific tide).
2. **Ranch** — the livestock are monsters (via Myra). Barn/coop gameplay with supernatural produce.
3. **Explore/Fight** — TWO distinct combat zones (the west Woods near town stay SAFE):
   - **The Deep Woods** (entrance far NW edge): combat vs. **mindless reanimated bodies** — wild risen zombies and skeletons (the failed reanimations, no one home). Physical enemies, melee/weapon combat. Purpose: resource gathering, crafting materials, exploration depth. *(How "defeating" reads tonally: they're already-dead husks, not people — clearing them is pest control, not killing. Keep them clearly inhuman: shamblers, rattling bone-piles.)*
   - **The caves beneath the manor** (entrance behind the waterfall, cliff's east face): the REAPER loop vs. **angry spirits** — souls, subdued into the scythe, passed on at the well for raw ghost light. (See Reaper loop below.)
   - The two zones split cleanly: **Deep Woods = bodies (the wild risen), caves = souls (the spirits).** Bodies rose because spirits leaked; you fight the symptom up in the woods and address the source down in the caves.
   - **Two tools, by design:** a **mundane melee weapon** (sword/axe — crafted/supplied via Briar) for the Deep Woods bodies, and the **scythe reserved for spirit-reaping** in the caves. Keeps the scythe sacred — it touches only souls, never hacks at husks. Separate upgrade paths/feels for each. *(Open: does the scythe ever work as a weapon in a pinch, or is the separation absolute? Leaning absolute — the scythe is an instrument of passage, not a blade.)*
4. **Reap (unlocks at act-one climax)** — THE REAPER LOOP (designer canon, 2026-06-13):
   - A **spirit well** sits in the base cave, just inside the cave entrance (behind the waterfall).
   - The player **descends** into the cave system; the deeper you go, the more **angry spirits** attack — restless souls curdled by years uncollected. *(Tone framing: "defeating" one = subduing/soothing it so the scythe can take it. This is the reaper's job, not killing — they're already dead; you're catching them.)*
   - **The scythe collects**: each subdued spirit is drawn into the scythe and carried.
   - **Return to the well** and transfer the carried spirits; the well **helps them pass on**.
   - Passing spirits on **generates raw ghost light for the player** — the reaper's wage, a refinable material (see Economy: raw → refine → refined resource).
   - **Scythe capacity:** limited, upgradeable. On collapse (stamina gone / overwhelmed), carried spirits ESCAPE back into the caves — work undone, not destroyed; player wakes at the manor.
   - **Ghost light is spent on (designer canon):** ① upgrading ALL gear — scythe, melee weapon, farm tools; ② powering manor restoration; ③ Victor's tech upgrades (the player's wage feeds his machine — deliberate moral friction); ④ lamps & town infrastructure (the Grove visibly brightens as the reaper works).
   - Open design questions: refining-station location · cave floor/depth structure & checkpoints · lore note: the well as the Grove's sanctioned door for souls ready to move on (interacts with the endgame — see spoiler doc).
5. **Befriend/Romance** — full marriage system + parallel found-family bonds.

## Progression Spine

- **Manor restoration bundles** (Community Center analog): each ruined room wants a themed item collection; restoring it unlocks a facility AND a piece of the story (Wilcox remembers more as his home heals).
- The restoration path leads to **the locked room** — the act-one climax and the unlock for reaper gameplay.
- Long-term story beats are paced to **Ghost-tides** (one reveal layer per year-cycle).
- Endgame: see spoiler doc. The whole map points down.

## Relationships

- **Full marriage system. Pool of 8 (4 male / 4 female) — COMPLETE.** Each a distinct archetype:
  - **Marshal** (M, swamp monster) — shy sweetheart
  - **Briar** (M, werewolf) — grump with a soft center
  - **Dorian** (M, siren) — dreamer/artist; lighthouse keeper & musician
  - **Rowan** (M, male dryad/nature-spirit) — elegant/nurturing
  - **Myra** (F, monster hunter) — confident adventurer
  - **Alice** (F, vampire) — composed intellectual
  - **Selene** (F, kitsune) — playful trickster
  - **Clementine** (F, Hazel's apprentice witch) — sunshine/warmth
  - Full archetype spread: shy, gruff, dreamy, elegant, bold, bookish, playful, sunshine — all eight distinct, none overlapping. Each wired to a different location/system. **All 8 named.**
- **Found-family track** for non-candidates runs parallel — heart events, manor spare rooms, chosen-family milestones.
- Gifting system will need **likes/dislikes per character (OPEN, whole cast)**.

## The Cast (16 entries; full sheets in Canva bible)

| Character | Species | Role | Notes |
|---|---|---|---|
| Wilcox | Ghost | Butler, tutorial guide | Proper, snobby, loyal; admits the player on seeing the crest pendant |
| Hazel | Witch (swamp witch) | Healer, cook, potions | Witch's shack deep in the swamp (southern half of the western Woods) |
| Benny | Reanimated skeleton | Bartender, comedian | Bar + family home in town; father of the twins; no memories, muscle memory only |
| Ellie | Skeleton (child) | Bar assistant | Chaos twin |
| Kellie | Skeleton (child) | Bar assistant | Responsible twin |
| Alastair | Cursed human | Museum curator | Cursed-artifact museum (collection content); his curse is his personal story; **Skitter (his pet) lives with him** |
| Marshal | Swamp monster | Sewer resident | Young adult; came via the river; lives under the bridge (sewer). **Commutes down to the swamp easily** — the connected waterways (sewer→river→swamp) are his native habitat; the swamp is his comfort zone (and Hazel's turf). **candidate** |
| Myra | Monster hunter | Sanctuary manager, livestock vendor | Found Benny & Cliff, caught Alice and took her in; **candidate** |
| Alice | Vampire (reformed) | Historian & library keeper | The town's historian and lore-voice — the library is the Grove's archive; bring her inscriptions/records and she researches them (mystery delivery runs through her). In recovery; lives with Myra; **candidate** |
| Victor | Human | Scientist, inventor, the town's power supply | Harvests ghost light from the caves — it powers the town's lights and his lab; argues with himself; uplifted the mindless risen into Benny, Cliff & the twins (public knowledge) |
| Sabrina | Human (child) | Victor's daughter | Little goth girl, Wednesday Addams energy |
| Jack | Scarecrow | Cornfield keeper | Never seen moving; attends festivals anyway; a running gag, NOT a mystery — never explained |
| Briar | Werewolf | Carpenter, building vendor | Shack near the Woods entrance; absent every Full Moon (felt, not seen); never laughs at Benny's jokes; **candidate** |
| Cliff | Zombie | Grave digger | Graveyard at the cliff-stairs' base; hut by the graves; pet crow Doug; sleeps in a dug grave ("Here Lies Cliff"); flowers pinned to chest; no shoes; muscle memory only |
| **Lionel** | Mummy | General store owner | An **English** archaeologist (1800s, Egyptology's golden age — the archaeologist who became the artifact), Shakespearean gravitas, grand weighty diction. **Big bushy grey eyebrows and a bushy grey moustache bursting out from under the mummy bandages.** |
| **Tobias** | Headless Horseman | **Mayor & festival host** | The town's civic heart — **carries his own head around** (sets it on the podium for speeches, tucks it under his arm, occasionally misplaces it — running gag). Dignified, warm, ceremonial. Story-role: likely the FIRST the Grove drew, who has welcomed every resident since — the town's "you belong here" made into a person. Runs the festivals (one per tide). **Mayor's office on the town square, connected to a stable with his horse Maple** (still rides — a nod to the Headless Horseman origins). |
| **Dorian** | Siren (male) | Lighthouse keeper & musician | **Marriage candidate** — the dreamer/artist (a siren whose nature IS song, so the musician role fits perfectly). Keeps the south/east-coast lighthouse; his music moves the whole town. Soulful, alluring-by-song, a touch melancholy. Name = "of the sea" + the Dorian musical mode. |
| **Selene** | Kitsune (fox spirit, female) | TBD | **Marriage candidate** — the playful trickster. Mischievous, teasing, flirtatious; the light, charming foil to the pool's guarded types. Moon-named fox spirit (kitsune have moon/night associations) — on-theme for the moonlit world. |
| **Rowan** | Dryad (male nature-spirit / Green Man) | TBD | **Marriage candidate** — the elegant/nurturing one. Calm, rooted, graceful; a male tree/forest spirit tied to the woods or cornfield. Slow-blooming, earthy romance. (Named for the rowan tree.) |
| **Clementine** | Witch (young) | Hazel's apprentice | **Marriage candidate** — the SUNSHINE one. Bubbly, bright, eager; Hazel's apprentice (gives Hazel story beats). The warm, open relief among the guarded types. ("Clem.") |

**Pets & companions (not townsfolk):** Skitter — a reanimated hand, silent and efficient, Alastair's pet/helper at the museum · Doug — Cliff's pet crow · Maple — Tobias's horse.

**Open town roles:** — all filled (general store = Lionel · lighthouse = Saska · mayor/festival host = the Headless Horseman).

## Geography (see `tiled/ghost-light-grove.tmx` + `map-draft-4.html`)

- **North edge:** tall dark treeline = map boundary; Deep Woods combat entrance cut into it at the far NW.
- **Elevation: three tiers** — manor cliff (highest, center-north) > **ridge line** (middle; runs horizontally edge-to-edge across the map) > town & lowlands (lowest, south of the ridge).
- **Center-north:** the manor on its **circular cliff**, back against the skyline, moon arcing overhead. Farm fields on the plateau; stairs descend south through **Cliff's graveyard**.
- **The waterfall** falls from the ridge to the lowlands; the **cave entrance is at its base, in the lowlands.**
- **Victor's lab** sits on the **mid-tier ridge, northeast (top-right)**; **mechanical piping runs from the lab down the cliff face into the low-tier caves** — the harvest infrastructure made visible on the map.
- **Hidden:** east off the stair path, hugging the cliff wall north — a **waterfall** where the river presses the cliff face, and beside it the **cave entrance** (caves run beneath the manor).
- **Town center:** square with a **canal** through the middle; **cobblestone bridge**; **sewer entrance beneath the bridge** (Marshal). Bar, museum, general store, library, and **Tobias's mayor's office** around the square. The office is **connected to a stable housing his horse Maple** (a nod to the Headless Horseman's origins — he still rides). **Victor's lab** to the **NORTHEAST**. **Cornfield** southeast.
- **West:** the Woods (safe). Upper half = forest — Briar's shack near the entrance. **Lower (southern) half = SWAMP — Hazel's witch shack** sits deep in it (Hazel = swamp witch).
- **Myra & Alice's monster ranch/sanctuary:** hugs the **manor cliff on its left (west) side, at the forest's edge** — between the safe Woods and the foot of the cliff.
- **South/East coast:** the **beach starts at center-south and wraps around the map edge to center-east** (L-shaped coastline); sea beyond, lighthouse on it. **A secluded cove (cul-de-sac) at the top-right, where the ridge meets the eastern beach.** *(Interpreting "colder sack" — confirm.)*
- **The river:** rises in **Hazel's swamp** (west), flows **horizontally west→east through town** (feeding the canal), then **forks after town** — one branch turns **north, hugs the cliff face past the waterfall, and exits off the north map edge** (Marshal's road in, from the wider waters beyond); the other branch runs **south to the beach** and sea.

## First Vertical Slice — "One Perfect Night"

Manor + small field: wake at dusk → farm with clock and stamina → one crop → sleep at dawn → dusk report → moon phase advances and visibly affects something. Static Wilcox as tutorial NPC. Proves the loop the game repeats 500 times. **Build this before anything else.**

## Tech Notes

- Map workflow: **Tiled** (installed), Stardew layer convention (Back / Buildings / Paths / Front / AlwaysFront + Locations object layer). Current blockout: `tiled/ghost-light-grove.tmx` on a CC0 tileset (GrafxKid overworld, placeholder).
- **Engine: MonoGame** (decided 2026-06-13). C#, code-first, the Stardew path. Tiled maps loaded at runtime.
- Art: placeholder packs for prototyping (Sprout Lands / Mystic Woods / Kenney discussed); concept art exists in Canva bible (note: AI-generated portraits contain Stardew watermark artifacts — reference only, never ship).

## Art & Asset Specs (Stardew-matched)

Target these dimensions/style for all art (matches Stardew Valley):
- **Base tile size: 16×16 px.** Everything snaps to this grid. Displayed at **4× zoom** (16px → 64px on screen), **pixel-perfect / nearest-neighbor** (no blur/anti-aliasing).
- **Overworld character sprites: 16×32 px** (one tile wide, two tall) — the walking sprites.
- **Dialogue portraits: 64×64 px** — the expressive face shown in conversation.
- **Objects / crops / items: 16×16** each (a crop's growth stages = a row of 16×16 frames).
- **Style = "HD pixel art," NOT retro.** Stardew uses a **generous palette** with soft shading/gradients — do NOT over-restrict colors. For AI prompts use "clean pixel art, rich palette, soft shading" rather than "8-bit / 4-color." Warm, cozy, readable, slightly painterly-within-pixels.
- **Ghost Light Grove twist on the style:** moonlit cozy-gothic — cool blue-grey night light with warm lantern highlights; whimsical, gently melancholic, never frightening (Over the Garden Wall / cozy Halloween).
- **AI prompt suffixes:** sprite → "16×32 top-down RPG sprite, transparent background, hard pixels"; portrait → "64×64 pixel portrait"; tile/object → "16×16, transparent bg, hard pixels."
- **Tools:** maps in **Tiled** (Stardew used tIDE); **character/sprite art generated in PixelLab** (native pixel-art AI — does rotations + animations + style-consistency); pixel cleanup in Aseprite. Concept art in Canva bible is reference only (has Stardew watermark artifacts — never ship).
- **PixelLab prompting:** DROP the technical tags ("pixel art, hard pixels, transparent bg, nearest-neighbor") — PixelLab does that natively. Give it a **clean character description** + set **size**, **view** (use a top-down / high-angle for overworld; side for portraits), and a **style reference image** to keep the whole cast consistent. Recommended: generate one hero character first, then use it as the style anchor for everyone else so the roster matches.

## Open Decisions (running list)

**Story** (details in spoiler doc): why grandfather left · what grandmother is now / her present-day identity · who's at risk if day returns (formal list — esp. Wilcox, Alice) · the town's collective stance on restoring the day · Victor & Sabrina's arrival wound · were Benny & the twins family in life (possibly never answered — by design).

**World/Systems:** tide names & flavors (proposed, unapproved) · scythe upgrade source · cave floor structure · general store owner · festival host · likes/dislikes pass · remaining 2 marriage candidates · arrival-story one-liners per resident · whether ghost light doubles as reaper-rank XP (see Economy).

**Deliberately unanswered (do not fill):** Jack · the player's parents (they exist only to create separation from the grandfather) · possibly the twins' in-life question.
