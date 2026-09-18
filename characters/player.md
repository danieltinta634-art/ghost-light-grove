---
name: The Player
species: Human
role: Protagonist — heir to the reaper's office
home: The manor
status: player character
candidate: false
pet: none (❓ open — starting pet/companion not decided)
look: "✅ confirmed — fully customizable (Stardew-style character creator); completely ordinary human, no visual hint of the reaper bloodline"
gifting: n/a — the player gives gifts, doesn't receive them as a mechanic
links: [Wilcox]
art_done: false
---

The player inherits a haunted manor in a hidden town of monsters — and
discovers the inheritance is more than a house. ✅ **Fully customizable,
Stardew-style:** the player picks their own appearance, name, and gender at
the start, same genre expectations as the games this is built alongside.

✅ **Two body types, tied to gender selection** (the classic Stardew
approach — not a fully decoupled body/pronoun system) — with **full
Stardew-scale customization range** on top: multiple skin tones, several
hairstyles and colors, a handful of starting outfit choices.

✅ **Completely ordinary, by design.** The player looks like anyone — no
birthmark, no eye color, no visual tell of the reaper bloodline. **The
pendant does 100% of the reveal work:** it's mundane outside the veil,
wakes on crossing it, and from then on the *pendant* is what marks the
player as significant (spirits take notice, Wilcox bows) — never the
player's own body. This keeps the character creator meaningfully "just a
person" right up until the story says otherwise.

## The Sprite System (technical, ✅ confirmed)

Unlike NPCs — whose equipped tools are baked directly into their character
sheet as full per-tool frame sets — **the player uses a layered/modular
sprite system**, Stardew's actual approach: a base body, a swappable hair
layer, a swappable outfit layer, and tools/weapons as their own separate
layer, all composited at runtime. This is the only way full customization
stays tractable — baking every hair × outfit × tool × animation-frame
combination the way NPCs do would multiply the art requirement
enormously. See `characters/art/player.md` for the production breakdown.

## Relationships
- **Wilcox** — admits the player to the manor on sight of the pendant;
  served the player's grandfather before them.

> **Open:** starting outfit specifics · exact skin tone / hairstyle / body
> type counts · starting pet or companion · name entry (free text vs.
> presets) · whether NPCs ever comment on the player's chosen appearance,
> or treat it as invisible the way most life-sims do.
