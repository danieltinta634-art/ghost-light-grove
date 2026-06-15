# One Perfect Night — Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A playable MonoGame build of Ghost Light Grove's core night loop: wake at dusk in the manor, farm one crop with a real clock and stamina, talk to Wilcox, sleep at dawn, read the dusk report, and watch the moon phase advance and visibly change the world.

**Architecture:** Two projects + tests. `GhostLightGrove.Core` (pure C# class lib, no MonoGame dependency) holds all simulation logic — clock, moon, stamina, crops, night advancement, TMX parsing — fully unit-tested with xUnit. `GhostLightGrove.Game` (MonoGame DesktopGL) is a thin shell: rendering, input, HUD. The existing Tiled map (`tiled/ghost-light-grove.tmx`, Stardew layer convention) is loaded at runtime by a small hand-rolled TMX parser (our maps are simple orthogonal CSV — no dependency needed). No MGCB content pipeline: textures via `Texture2D.FromFile`, text via FontStashSharp.

**Tech Stack:** .NET 8 target (SDK 10 installed) · MonoGame 3.8 DesktopGL · xUnit · FontStashSharp (runtime TTF text) · existing CC0 tileset.

**Placeholder policy:** All art is colored rectangles or tileset tiles; all names/dialogue marked `[PLACEHOLDER]` are not canon — designer replaces later.

**Project home:** `C:\Users\danie\GhostLightGrove\` (docs + maps live here; code goes in `game\`). All commands below run from this directory unless stated.

---

### Task 0: Git repository

**Files:**
- Create: `C:\Users\danie\GhostLightGrove\.gitignore`

- [ ] **Step 1: Init repo and ignore build output**

```powershell
cd C:\Users\danie\GhostLightGrove
git init
```

Create `.gitignore`:

```gitignore
bin/
obj/
*.user
.vs/
*.DotSettings
```

- [ ] **Step 2: Initial commit of existing design assets**

```powershell
git add .
git commit -m "chore: import design docs, maps, and tileset"
```

Expected: commit succeeds; `git status` clean.

---

### Task 1: Solution scaffold

**Files:**
- Create: `game/GhostLightGrove.sln`, `game/src/GhostLightGrove.Core/`, `game/src/GhostLightGrove.Game/`, `game/tests/GhostLightGrove.Core.Tests/`

- [ ] **Step 1: Install MonoGame templates**

```powershell
dotnet new install MonoGame.Templates.CSharp
```

Expected: lists `MonoGame Cross-Platform Desktop Application (mgdesktopgl)`.

- [ ] **Step 2: Create projects and solution**

```powershell
mkdir game; cd game
dotnet new sln -n GhostLightGrove
dotnet new mgdesktopgl -o src/GhostLightGrove.Game -n GhostLightGrove.Game
dotnet new classlib -o src/GhostLightGrove.Core -n GhostLightGrove.Core -f net8.0
dotnet new xunit -o tests/GhostLightGrove.Core.Tests -n GhostLightGrove.Core.Tests -f net8.0
dotnet sln add src/GhostLightGrove.Game src/GhostLightGrove.Core tests/GhostLightGrove.Core.Tests
dotnet add src/GhostLightGrove.Game reference src/GhostLightGrove.Core
dotnet add tests/GhostLightGrove.Core.Tests reference src/GhostLightGrove.Core
dotnet add src/GhostLightGrove.Game package FontStashSharp.MonoGame
del src\GhostLightGrove.Core\Class1.cs
```

- [ ] **Step 3: Ensure implicit usings are enabled in all three csproj files**

The plan's code relies on implicit usings (`System`, `System.IO`, `System.Linq`, `System.Collections.Generic`). Check each `.csproj` contains `<ImplicitUsings>enable</ImplicitUsings>` in its first `<PropertyGroup>`; add it if missing.

- [ ] **Step 4: Verify everything builds and the empty test suite runs**

```powershell
dotnet build GhostLightGrove.sln
dotnet test GhostLightGrove.sln
```

Expected: build succeeds; 1 placeholder xunit test passes. (First MonoGame build restores content-builder tools; may take a minute.)

- [ ] **Step 4: Sanity-run the blank game window**

```powershell
dotnet run --project src/GhostLightGrove.Game
```

Expected: a cornflower-blue window opens. Close it.

- [ ] **Step 5: Commit**

```powershell
cd C:\Users\danie\GhostLightGrove
git add game
git commit -m "feat: scaffold MonoGame solution (Game, Core, Tests)"
```

---

### Task 2: GameClock (Core, TDD)

The night runs 6:00 PM → 6:00 AM (720 game-minutes) in 15 real minutes → **0.8 game-minutes per real second**.

**Files:**
- Create: `game/src/GhostLightGrove.Core/GameClock.cs`
- Test: `game/tests/GhostLightGrove.Core.Tests/GameClockTests.cs`

- [ ] **Step 1: Write failing tests** (delete the template's `UnitTest1.cs`)

```csharp
using GhostLightGrove.Core;
using Xunit;

public class GameClockTests
{
    [Fact]
    public void StartsAtDusk_SixPm()
    {
        var c = new GameClock();
        Assert.Equal("6:00 PM", c.DisplayTime);
        Assert.False(c.IsDawn);
    }

    [Fact]
    public void Advances_PointEightGameMinutesPerRealSecond()
    {
        var c = new GameClock();
        c.Advance(750f); // 750s * 0.8 = 600 game-min -> 4:00 AM
        Assert.Equal("4:00 AM", c.DisplayTime);
        Assert.False(c.IsDawn);
    }

    [Fact]
    public void DawnAtSixAm_AndClampsThere()
    {
        var c = new GameClock();
        c.Advance(10000f);
        Assert.True(c.IsDawn);
        Assert.Equal("6:00 AM", c.DisplayTime);
    }

    [Fact]
    public void ResetToDusk_StartsNewNight()
    {
        var c = new GameClock();
        c.Advance(10000f);
        c.ResetToDusk();
        Assert.Equal("6:00 PM", c.DisplayTime);
        Assert.False(c.IsDawn);
    }
}
```

- [ ] **Step 2: Run to verify failure**

Run: `dotnet test game/GhostLightGrove.sln`
Expected: FAIL — `GameClock` not defined.

- [ ] **Step 3: Implement**

```csharp
namespace GhostLightGrove.Core;

public sealed class GameClock
{
    public const float GameMinutesPerRealSecond = 0.8f; // 12h night in 15 real minutes
    public const float NightLengthMinutes = 720f;

    public float MinutesSinceDusk { get; private set; }

    public bool IsDawn => MinutesSinceDusk >= NightLengthMinutes;

    public void Advance(float realSeconds) =>
        MinutesSinceDusk = Math.Min(NightLengthMinutes,
            MinutesSinceDusk + realSeconds * GameMinutesPerRealSecond);

    public void ResetToDusk() => MinutesSinceDusk = 0f;

    public string DisplayTime
    {
        get
        {
            int total = (18 * 60 + (int)MinutesSinceDusk) % 1440;
            int h24 = total / 60, m = total % 60;
            int h12 = h24 % 12; if (h12 == 0) h12 = 12;
            return $"{h12}:{m:D2} {(h24 < 12 ? "AM" : "PM")}";
        }
    }
}
```

- [ ] **Step 4: Run tests — expect PASS**

Run: `dotnet test game/GhostLightGrove.sln` → all green.

- [ ] **Step 5: Commit**

```powershell
git add game
git commit -m "feat(core): GameClock - 15-minute night, dusk to dawn"
```

---

### Task 3: MoonCycle (Core, TDD)

Canon: 7-night week, phase changes nightly, **Full Moon closes each week** (nights 7, 14, 21…). Brightness drives the night tint in-game. Phase names are `[PLACEHOLDER]`.

**Files:**
- Create: `game/src/GhostLightGrove.Core/MoonCycle.cs`
- Test: `game/tests/GhostLightGrove.Core.Tests/MoonCycleTests.cs`

- [ ] **Step 1: Write failing tests**

```csharp
using GhostLightGrove.Core;
using Xunit;

public class MoonCycleTests
{
    [Fact]
    public void NightOne_IsNewMoon_NotFull()
    {
        var m = new MoonCycle();
        Assert.Equal(1, m.Night);
        Assert.Equal(0, m.PhaseIndex);
        Assert.False(m.IsFullMoon);
    }

    [Fact]
    public void NightSeven_IsFullMoon()
    {
        var m = new MoonCycle();
        for (int i = 0; i < 6; i++) m.AdvanceNight();
        Assert.Equal(7, m.Night);
        Assert.True(m.IsFullMoon);
    }

    [Fact]
    public void CycleRepeats_NightEightIsNewAgain()
    {
        var m = new MoonCycle();
        for (int i = 0; i < 7; i++) m.AdvanceNight();
        Assert.Equal(8, m.Night);
        Assert.Equal(0, m.PhaseIndex);
        Assert.False(m.IsFullMoon);
    }

    [Fact]
    public void Brightness_RisesAcrossTheWeek()
    {
        var m = new MoonCycle();
        float newMoon = m.Brightness;
        for (int i = 0; i < 6; i++) m.AdvanceNight();
        Assert.True(m.Brightness > newMoon);
        Assert.Equal(1f, m.Brightness, 3);
    }
}
```

- [ ] **Step 2: Run — expect FAIL** (`MoonCycle` not defined)

- [ ] **Step 3: Implement**

```csharp
namespace GhostLightGrove.Core;

public sealed class MoonCycle
{
    // [PLACEHOLDER] phase names — designer to rename
    public static readonly string[] PhaseNames =
        { "New Moon", "Waxing Sliver", "Quarter Moon", "Half Light",
          "Waxing Gibbous", "Almost Full", "Full Moon" };

    public int Night { get; private set; } = 1;
    public int PhaseIndex => (Night - 1) % 7;
    public string PhaseName => PhaseNames[PhaseIndex];
    public bool IsFullMoon => PhaseIndex == 6;

    /// 0.35 (new) .. 1.0 (full) — multiplies ambient light in-game.
    public float Brightness => 0.35f + 0.65f * (PhaseIndex / 6f);

    public void AdvanceNight() => Night++;
}
```

- [ ] **Step 4: Run tests — expect PASS**

- [ ] **Step 5: Commit** — `git add game && git commit -m "feat(core): MoonCycle - 7-night week, weekly full moon"`

---

### Task 4: Stamina (Core, TDD)

**Files:**
- Create: `game/src/GhostLightGrove.Core/Stamina.cs`
- Test: `game/tests/GhostLightGrove.Core.Tests/StaminaTests.cs`

- [ ] **Step 1: Write failing tests**

```csharp
using GhostLightGrove.Core;
using Xunit;

public class StaminaTests
{
    [Fact]
    public void StartsFull()
    {
        var s = new Stamina(100f);
        Assert.Equal(100f, s.Current);
    }

    [Fact]
    public void TrySpend_Deducts_WhenAffordable()
    {
        var s = new Stamina(100f);
        Assert.True(s.TrySpend(30f));
        Assert.Equal(70f, s.Current);
    }

    [Fact]
    public void TrySpend_Refuses_WhenInsufficient()
    {
        var s = new Stamina(10f);
        Assert.True(s.TrySpend(10f));
        Assert.False(s.TrySpend(0.1f));
        Assert.Equal(0f, s.Current);
    }

    [Fact]
    public void RestoreFull_RefillsToMax()
    {
        var s = new Stamina(100f);
        s.TrySpend(80f);
        s.RestoreFull();
        Assert.Equal(100f, s.Current);
    }
}
```

- [ ] **Step 2: Run — expect FAIL**

- [ ] **Step 3: Implement**

```csharp
namespace GhostLightGrove.Core;

public sealed class Stamina
{
    public float Max { get; }
    public float Current { get; private set; }

    public Stamina(float max) { Max = max; Current = max; }

    public bool TrySpend(float amount)
    {
        if (Current < amount) return false;
        Current -= amount;
        return true;
    }

    public void RestoreFull() => Current = Max;
}
```

- [ ] **Step 4: Run tests — expect PASS**

- [ ] **Step 5: Commit** — `git add game && git commit -m "feat(core): Stamina"`

---

### Task 5: Crops & FarmPlot (Core, TDD)

One crop for the slice. Growth: planted + watered → +1 stage per night, **+2 on a Full Moon night** (the moon's visible effect). Water resets nightly.

**Files:**
- Create: `game/src/GhostLightGrove.Core/Farming.cs`
- Test: `game/tests/GhostLightGrove.Core.Tests/FarmPlotTests.cs`

- [ ] **Step 1: Write failing tests**

```csharp
using GhostLightGrove.Core;
using Xunit;

public class FarmPlotTests
{
    private static readonly CropDef Moonberry = new("Moonberry [PLACEHOLDER]", 3);

    [Fact]
    public void LifeCycle_TillPlantWaterGrowHarvest()
    {
        var p = new FarmPlot();
        Assert.Equal(PlotState.Untilled, p.State);
        Assert.True(p.Till());
        Assert.True(p.Plant(Moonberry));
        Assert.True(p.Water());

        for (int night = 0; night < 3; night++)
        {
            p.AdvanceNight(fullMoon: false);
            if (night < 2) p.Water();
        }

        Assert.True(p.IsMature);
        Assert.Equal("Moonberry [PLACEHOLDER]", p.Harvest());
        Assert.Equal(PlotState.Tilled, p.State);
    }

    [Fact]
    public void UnwateredCrop_DoesNotGrow()
    {
        var p = new FarmPlot();
        p.Till(); p.Plant(Moonberry);
        p.AdvanceNight(fullMoon: false);
        Assert.Equal(0, p.GrowthNights);
    }

    [Fact]
    public void FullMoon_GrowsDouble()
    {
        var p = new FarmPlot();
        p.Till(); p.Plant(Moonberry); p.Water();
        p.AdvanceNight(fullMoon: true);
        Assert.Equal(2, p.GrowthNights);
    }

    [Fact]
    public void Watered_ResetsEachNight()
    {
        var p = new FarmPlot();
        p.Till(); p.Plant(Moonberry); p.Water();
        p.AdvanceNight(fullMoon: false);
        Assert.False(p.Watered);
    }

    [Fact]
    public void InvalidTransitions_ReturnFalse()
    {
        var p = new FarmPlot();
        Assert.False(p.Plant(Moonberry));   // can't plant untilled
        Assert.False(p.Water());            // can't water untilled
        Assert.Null(p.Harvest());           // nothing to harvest
        p.Till();
        Assert.False(p.Till());             // already tilled
    }
}
```

- [ ] **Step 2: Run — expect FAIL**

- [ ] **Step 3: Implement**

```csharp
namespace GhostLightGrove.Core;

public sealed record CropDef(string Name, int NightsToMature);

public enum PlotState { Untilled, Tilled, Planted }

public sealed class FarmPlot
{
    public PlotState State { get; private set; } = PlotState.Untilled;
    public CropDef? Crop { get; private set; }
    public int GrowthNights { get; private set; }
    public bool Watered { get; private set; }

    public bool IsMature =>
        State == PlotState.Planted && Crop != null && GrowthNights >= Crop.NightsToMature;

    public bool Till()
    {
        if (State != PlotState.Untilled) return false;
        State = PlotState.Tilled;
        return true;
    }

    public bool Plant(CropDef crop)
    {
        if (State != PlotState.Tilled) return false;
        Crop = crop; GrowthNights = 0; State = PlotState.Planted;
        return true;
    }

    public bool Water()
    {
        if (State == PlotState.Untilled || Watered) return false;
        Watered = true;
        return true;
    }

    /// Returns true if the crop grew tonight.
    public bool AdvanceNight(bool fullMoon)
    {
        bool grew = false;
        if (State == PlotState.Planted && Watered && !IsMature)
        {
            GrowthNights += fullMoon ? 2 : 1;
            grew = true;
        }
        Watered = false;
        return grew;
    }

    public string? Harvest()
    {
        if (!IsMature) return null;
        string name = Crop!.Name;
        Crop = null; GrowthNights = 0; State = PlotState.Tilled;
        return name;
    }
}
```

- [ ] **Step 4: Run tests — expect PASS**

- [ ] **Step 5: Commit** — `git add game && git commit -m "feat(core): FarmPlot crop lifecycle with full-moon growth bonus"`

---

### Task 6: NightSimulator & DuskReport (Core, TDD)

One function advances the world across a sleep: grow plots (using *tonight's* phase), advance moon, emit report lines.

**Files:**
- Create: `game/src/GhostLightGrove.Core/NightSimulator.cs`
- Test: `game/tests/GhostLightGrove.Core.Tests/NightSimulatorTests.cs`

- [ ] **Step 1: Write failing tests**

```csharp
using System.Linq;
using GhostLightGrove.Core;
using Xunit;

public class NightSimulatorTests
{
    private static readonly CropDef Moonberry = new("Moonberry [PLACEHOLDER]", 3);

    private static FarmPlot PlantedWatered()
    {
        var p = new FarmPlot();
        p.Till(); p.Plant(Moonberry); p.Water();
        return p;
    }

    [Fact]
    public void GrowsWateredPlots_AdvancesMoon_Reports()
    {
        var plots = new[] { PlantedWatered(), new FarmPlot() };
        var moon = new MoonCycle();

        var report = NightSimulator.AdvanceNight(plots, moon);

        Assert.Equal(1, plots[0].GrowthNights);
        Assert.Equal(2, moon.Night);
        Assert.Contains(report.Lines, l => l.Contains("1 crop"));
        Assert.Contains(report.Lines, l => l.Contains(moon.PhaseName));
    }

    [Fact]
    public void FullMoonNight_UsesBonus_AndSaysSo()
    {
        var plots = new[] { PlantedWatered() };
        var moon = new MoonCycle();
        for (int i = 0; i < 6; i++) moon.AdvanceNight(); // night 7 = full

        var report = NightSimulator.AdvanceNight(plots, moon);

        Assert.Equal(2, plots[0].GrowthNights);
        Assert.Contains(report.Lines, l => l.Contains("full moon", System.StringComparison.OrdinalIgnoreCase));
    }

    [Fact]
    public void ReportsHarvestReady()
    {
        var p = PlantedWatered();
        var moon = new MoonCycle();
        for (int i = 0; i < 3; i++)
        {
            NightSimulator.AdvanceNight(new[] { p }, moon);
            p.Water();
        }
        Assert.True(p.IsMature);
        var report = NightSimulator.AdvanceNight(new[] { p }, moon);
        Assert.Contains(report.Lines, l => l.Contains("ready to harvest"));
    }
}
```

- [ ] **Step 2: Run — expect FAIL**

- [ ] **Step 3: Implement**

```csharp
namespace GhostLightGrove.Core;

public sealed record DuskReport(IReadOnlyList<string> Lines);

public static class NightSimulator
{
    public static DuskReport AdvanceNight(IReadOnlyCollection<FarmPlot> plots, MoonCycle moon)
    {
        bool wasFullMoon = moon.IsFullMoon;
        int grew = plots.Count(p => p.AdvanceNight(wasFullMoon));
        moon.AdvanceNight();

        var lines = new List<string>();
        if (grew > 0)
            lines.Add(wasFullMoon
                ? $"{grew} crop(s) surged in the full moonlight."
                : $"{grew} crop(s) grew while you slept.");
        int ready = plots.Count(p => p.IsMature);
        if (ready > 0)
            lines.Add($"{ready} crop(s) are ready to harvest.");
        lines.Add($"Tonight's moon: {moon.PhaseName}.");
        if (lines.Count == 1)
            lines.Insert(0, "The Grove was quiet while you slept. [PLACEHOLDER flavor]");
        return new DuskReport(lines);
    }
}
```

- [ ] **Step 4: Run tests — expect PASS** (note: the full-moon test asserts "full moon" appears — it does, in "surged in the full moonlight")

- [ ] **Step 5: Commit** — `git add game && git commit -m "feat(core): NightSimulator + DuskReport"`

---

### Task 7: TMX map parser (Core, TDD against the real map)

Parses our actual `tiled/ghost-light-grove.tmx`: orthogonal, CSV-encoded layers, one external `.tsx` tileset, one objectgroup. No MonoGame types (tuples instead of Rectangle) so it stays testable.

**Files:**
- Create: `game/src/GhostLightGrove.Core/Tmx.cs`
- Test: `game/tests/GhostLightGrove.Core.Tests/TmxMapTests.cs`

- [ ] **Step 1: Write failing tests**

```csharp
using System;
using System.IO;
using System.Linq;
using GhostLightGrove.Core;
using Xunit;

public class TmxMapTests
{
    private static string FindMapPath()
    {
        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        while (dir != null)
        {
            string candidate = Path.Combine(dir.FullName, "tiled", "ghost-light-grove.tmx");
            if (File.Exists(candidate)) return candidate;
            dir = dir.Parent;
        }
        throw new FileNotFoundException("ghost-light-grove.tmx not found above test dir");
    }

    [Fact]
    public void LoadsDimensionsAndLayers()
    {
        var map = TmxMap.Load(FindMapPath());
        Assert.Equal(80, map.Width);
        Assert.Equal(60, map.Height);
        Assert.Equal(16, map.TileWidth);
        Assert.Contains(map.Layers, l => l.Name == "Back");
        Assert.Contains(map.Layers, l => l.Name == "Buildings");
    }

    [Fact]
    public void BackLayer_HasGrassAtOrigin_AndSeaAtBottom()
    {
        var map = TmxMap.Load(FindMapPath());
        var back = map.Layer("Back");
        Assert.NotEqual(0, back.GidAt(0, 0));      // treeline tile, non-empty
        Assert.Equal(62, back.GidAt(10, 55));      // sea = water gid 62
    }

    [Fact]
    public void FindsNamedObjects()
    {
        var map = TmxMap.Load(FindMapPath());
        var manor = map.Objects.Single(o => o.Name == "THE MANOR");
        Assert.True(manor.Width > 0);
        Assert.Contains(map.Objects, o => o.Name == "farm fields");
    }

    [Fact]
    public void Tileset_ResolvesImageAndSourceRects()
    {
        var map = TmxMap.Load(FindMapPath());
        Assert.True(File.Exists(map.Tileset.ImagePath), $"missing: {map.Tileset.ImagePath}");
        var (sx, sy) = map.Tileset.GetSource(2); // gid 2 = tile id 1 = col 1, row 0
        Assert.Equal(16, sx);
        Assert.Equal(0, sy);
    }
}
```

- [ ] **Step 2: Run — expect FAIL**

- [ ] **Step 3: Implement**

```csharp
using System.Xml.Linq;

namespace GhostLightGrove.Core;

public sealed record TmxObject(string Name, float X, float Y, float Width, float Height);

public sealed class TmxLayer
{
    public required string Name { get; init; }
    public required int Width { get; init; }
    public required int Height { get; init; }
    public required int[] Gids { get; init; }
    public int GidAt(int tx, int ty) =>
        tx < 0 || ty < 0 || tx >= Width || ty >= Height ? 0 : Gids[ty * Width + tx];
}

public sealed class TmxTileset
{
    public required int FirstGid { get; init; }
    public required int Columns { get; init; }
    public required int TileWidth { get; init; }
    public required int TileHeight { get; init; }
    public required string ImagePath { get; init; }

    public (int sx, int sy) GetSource(int gid)
    {
        int id = gid - FirstGid;
        return (id % Columns * TileWidth, id / Columns * TileHeight);
    }
}

public sealed class TmxMap
{
    public required int Width { get; init; }
    public required int Height { get; init; }
    public required int TileWidth { get; init; }
    public required IReadOnlyList<TmxLayer> Layers { get; init; }
    public required IReadOnlyList<TmxObject> Objects { get; init; }
    public required TmxTileset Tileset { get; init; }

    public TmxLayer Layer(string name) => Layers.First(l => l.Name == name);

    public static TmxMap Load(string tmxPath)
    {
        var doc = XDocument.Load(tmxPath);
        var mapEl = doc.Root!;
        string mapDir = Path.GetDirectoryName(Path.GetFullPath(tmxPath))!;

        // external tileset
        var tsEl = mapEl.Element("tileset")!;
        int firstGid = (int)tsEl.Attribute("firstgid")!;
        string tsxPath = Path.GetFullPath(Path.Combine(mapDir, (string)tsEl.Attribute("source")!));
        var tsx = XDocument.Load(tsxPath).Root!;
        var imgEl = tsx.Element("image")!;
        string imagePath = Path.GetFullPath(
            Path.Combine(Path.GetDirectoryName(tsxPath)!, (string)imgEl.Attribute("source")!));

        var tileset = new TmxTileset
        {
            FirstGid = firstGid,
            Columns = (int)tsx.Attribute("columns")!,
            TileWidth = (int)tsx.Attribute("tilewidth")!,
            TileHeight = (int)tsx.Attribute("tileheight")!,
            ImagePath = imagePath,
        };

        var layers = mapEl.Elements("layer").Select(l => new TmxLayer
        {
            Name = (string)l.Attribute("name")!,
            Width = (int)l.Attribute("width")!,
            Height = (int)l.Attribute("height")!,
            Gids = l.Element("data")!.Value
                    .Split(',', StringSplitOptions.TrimEntries | StringSplitOptions.RemoveEmptyEntries)
                    .Select(int.Parse).ToArray(),
        }).ToList();

        var objects = mapEl.Elements("objectgroup").Elements("object").Select(o => new TmxObject(
            (string?)o.Attribute("name") ?? "",
            (float)o.Attribute("x")!, (float)o.Attribute("y")!,
            (float?)o.Attribute("width") ?? 0f, (float?)o.Attribute("height") ?? 0f)).ToList();

        return new TmxMap
        {
            Width = (int)mapEl.Attribute("width")!,
            Height = (int)mapEl.Attribute("height")!,
            TileWidth = (int)mapEl.Attribute("tilewidth")!,
            Layers = layers,
            Objects = objects,
            Tileset = tileset,
        };
    }
}
```

- [ ] **Step 4: Run tests — expect PASS** (these load the real map file by walking up from bin/)

- [ ] **Step 5: Commit** — `git add game && git commit -m "feat(core): minimal TMX/TSX parser tested against the real map"`

---

### Task 8: Game shell — map on screen with a camera

**Files:**
- Create: `game/src/GhostLightGrove.Game/Assets/` (copied map + tileset)
- Create: `game/src/GhostLightGrove.Game/GroveGame.cs`
- Modify: `game/src/GhostLightGrove.Game/Program.cs`
- Delete: `game/src/GhostLightGrove.Game/Game1.cs`
- Modify: `game/src/GhostLightGrove.Game/GhostLightGrove.Game.csproj`

- [ ] **Step 1: Copy runtime assets and wire copy-to-output**

```powershell
cd C:\Users\danie\GhostLightGrove
mkdir game\src\GhostLightGrove.Game\Assets\tilesets\TilesetGrass -Force
Copy-Item tiled\ghost-light-grove.tmx game\src\GhostLightGrove.Game\Assets\
Copy-Item tiled\tilesets\TilesetGrass\grass_biome.tsx game\src\GhostLightGrove.Game\Assets\tilesets\TilesetGrass\
Copy-Item tiled\tilesets\TilesetGrass\overworld_tileset_grass.png game\src\GhostLightGrove.Game\Assets\tilesets\TilesetGrass\
```

Add inside `GhostLightGrove.Game.csproj`'s root `<Project>` element:

```xml
<ItemGroup>
  <None Include="Assets\**\*" CopyToOutputDirectory="PreserveNewest" />
</ItemGroup>
```

(Note: the copied TMX references `tilesets/TilesetGrass/grass_biome.tsx` relatively — the folder structure above preserves that.)

- [ ] **Step 2: Replace Game1 with GroveGame rendering the map**

Delete `Game1.cs`. Create `GroveGame.cs`:

```csharp
using System;
using System.IO;
using GhostLightGrove.Core;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace GhostLightGrove.Game;

public class GroveGame : Microsoft.Xna.Framework.Game
{
    public const int Scale = 3;

    private readonly GraphicsDeviceManager _graphics;
    private SpriteBatch _spriteBatch = null!;

    private TmxMap _map = null!;
    private Texture2D _tilesetTexture = null!;
    private Texture2D _pixel = null!;
    private Vector2 _cameraCenter; // world pixels

    public GroveGame()
    {
        _graphics = new GraphicsDeviceManager(this)
        {
            PreferredBackBufferWidth = 1280,
            PreferredBackBufferHeight = 800,
        };
        IsMouseVisible = true;
        Window.Title = "Ghost Light Grove — One Perfect Night";
    }

    protected override void LoadContent()
    {
        _spriteBatch = new SpriteBatch(GraphicsDevice);

        string assets = Path.Combine(AppContext.BaseDirectory, "Assets");
        _map = TmxMap.Load(Path.Combine(assets, "ghost-light-grove.tmx"));
        _tilesetTexture = Texture2D.FromFile(GraphicsDevice, _map.Tileset.ImagePath);

        _pixel = new Texture2D(GraphicsDevice, 1, 1);
        _pixel.SetData(new[] { Color.White });

        var manor = _map.Objects.First(o => o.Name == "THE MANOR");
        _cameraCenter = new Vector2(manor.X + manor.Width / 2, manor.Y + manor.Height + 16);
    }

    protected override void Update(GameTime gameTime)
    {
        if (Keyboard.GetState().IsKeyDown(Keys.Escape)) Exit();
        base.Update(gameTime);
    }

    private Matrix CameraTransform()
    {
        var view = new Vector2(_graphics.PreferredBackBufferWidth, _graphics.PreferredBackBufferHeight);
        Vector2 topLeft = _cameraCenter - view / (2f * Scale);
        float maxX = _map.Width * _map.TileWidth - view.X / Scale;
        float maxY = _map.Height * _map.TileWidth - view.Y / Scale;
        topLeft.X = MathHelper.Clamp(topLeft.X, 0, Math.Max(0, maxX));
        topLeft.Y = MathHelper.Clamp(topLeft.Y, 0, Math.Max(0, maxY));
        return Matrix.CreateTranslation(-topLeft.X, -topLeft.Y, 0) * Matrix.CreateScale(Scale);
    }

    private void DrawLayer(TmxLayer layer)
    {
        int ts = _map.TileWidth;
        for (int ty = 0; ty < layer.Height; ty++)
        for (int tx = 0; tx < layer.Width; tx++)
        {
            int gid = layer.GidAt(tx, ty);
            if (gid == 0) continue;
            var (sx, sy) = _map.Tileset.GetSource(gid);
            _spriteBatch.Draw(_tilesetTexture,
                new Vector2(tx * ts, ty * ts),
                new Rectangle(sx, sy, ts, ts), Color.White);
        }
    }

    protected override void Draw(GameTime gameTime)
    {
        GraphicsDevice.Clear(new Color(10, 14, 28));
        _spriteBatch.Begin(samplerState: SamplerState.PointClamp, transformMatrix: CameraTransform());
        DrawLayer(_map.Layer("Back"));
        DrawLayer(_map.Layer("Buildings"));
        _spriteBatch.End();
        base.Draw(gameTime);
    }
}
```

Update `Program.cs`:

```csharp
using var game = new GhostLightGrove.Game.GroveGame();
game.Run();
```

- [ ] **Step 3: Run and verify visually**

Run: `dotnet run --project game/src/GhostLightGrove.Game`
Expected: window opens showing the plateau area of the map (manor zone, farm rows, cliff edge, graveyard below), pixel-crisp at 3×. Esc quits.

- [ ] **Step 4: Commit** — `git add game && git commit -m "feat(game): render Tiled map with clamped camera"`

---

### Task 9: Player movement & collision

Blocking rules: any nonzero gid on `Buildings`, or water (gid 62) on `Back`. Player is a placeholder 12×16 rectangle.

**Files:**
- Create: `game/src/GhostLightGrove.Game/Player.cs`
- Modify: `game/src/GhostLightGrove.Game/GroveGame.cs`

- [ ] **Step 1: Create Player.cs**

```csharp
using GhostLightGrove.Core;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;

namespace GhostLightGrove.Game;

public sealed class Player
{
    public const float Speed = 90f; // px/sec
    public const int WaterGid = 62;

    public Vector2 Position; // feet center, world px
    public Point Facing = new(0, 1);

    private readonly TmxMap _map;
    private readonly TmxLayer _buildings;
    private readonly TmxLayer _back;

    public Player(TmxMap map, Vector2 spawn)
    {
        _map = map;
        _buildings = map.Layer("Buildings");
        _back = map.Layer("Back");
        Position = spawn;
    }

    public Point Tile => new((int)(Position.X / _map.TileWidth), (int)(Position.Y / _map.TileWidth));
    public Point FacingTile => new(Tile.X + Facing.X, Tile.Y + Facing.Y);

    private bool Blocked(Vector2 pos)
    {
        int tx = (int)(pos.X / _map.TileWidth), ty = (int)(pos.Y / _map.TileWidth);
        return _buildings.GidAt(tx, ty) != 0 || _back.GidAt(tx, ty) == WaterGid;
    }

    public void Update(float dt, KeyboardState keys)
    {
        var dir = Vector2.Zero;
        if (keys.IsKeyDown(Keys.W) || keys.IsKeyDown(Keys.Up)) dir.Y -= 1;
        if (keys.IsKeyDown(Keys.S) || keys.IsKeyDown(Keys.Down)) dir.Y += 1;
        if (keys.IsKeyDown(Keys.A) || keys.IsKeyDown(Keys.Left)) dir.X -= 1;
        if (keys.IsKeyDown(Keys.D) || keys.IsKeyDown(Keys.Right)) dir.X += 1;
        if (dir == Vector2.Zero) return;

        dir.Normalize();
        Facing = new Point(Math.Sign(MathF.Round(dir.X)), Math.Sign(MathF.Round(dir.Y)));

        var next = Position + dir * Speed * dt;
        if (!Blocked(new Vector2(next.X, Position.Y))) Position.X = next.X;
        if (!Blocked(new Vector2(Position.X, next.Y))) Position.Y = next.Y;
    }
}
```

- [ ] **Step 2: Wire into GroveGame**

Add field after `_cameraCenter`:

```csharp
private Player _player = null!;
```

At the end of `LoadContent()` (replace the `_cameraCenter` assignment):

```csharp
var manor = _map.Objects.First(o => o.Name == "THE MANOR");
_player = new Player(_map, new Vector2(manor.X + manor.Width / 2, manor.Y + manor.Height + 24));
```

In `Update()` before `base.Update`:

```csharp
float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;
var keys = Keyboard.GetState();
_player.Update(dt, keys);
_cameraCenter = _player.Position;
```

In `Draw()` after `DrawLayer(_map.Layer("Buildings"));`:

```csharp
_spriteBatch.Draw(_pixel,
    new Rectangle((int)_player.Position.X - 6, (int)_player.Position.Y - 14, 12, 16),
    new Color(240, 235, 220)); // [PLACEHOLDER] player sprite
```

- [ ] **Step 3: Run and verify**

Run: `dotnet run --project game/src/GhostLightGrove.Game`
Expected: walk with WASD; camera follows; you cannot walk through the bridge tiles, graves, or into the sea/canal; you CAN roam the plateau and down the open map.

- [ ] **Step 4: Commit** — `git add game && git commit -m "feat(game): player movement with tile collision"`

---

### Task 10: HUD — clock, stamina, moon, night tint

**Files:**
- Modify: `game/src/GhostLightGrove.Game/GroveGame.cs`
- Create: `game/src/GhostLightGrove.Game/Hud.cs`

- [ ] **Step 1: Create Hud.cs (FontStashSharp text + bars)**

```csharp
using FontStashSharp;
using GhostLightGrove.Core;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace GhostLightGrove.Game;

public sealed class Hud
{
    private readonly FontSystem _fonts = new();
    private readonly Texture2D _pixel;

    public Hud(Texture2D pixel)
    {
        _pixel = pixel;
        _fonts.AddFont(File.ReadAllBytes(@"C:\Windows\Fonts\segoeui.ttf"));
    }

    public DynamicSpriteFont Font(int size) => _fonts.GetFont(size);

    public void Draw(SpriteBatch sb, GameClock clock, MoonCycle moon, Stamina stamina, Point screen)
    {
        var font = Font(26);
        // top-right: time + moon
        string time = clock.DisplayTime;
        string moonLine = $"Night {moon.Night} — {moon.PhaseName}";
        var timeSize = font.MeasureString(time);
        var moonSize = font.MeasureString(moonLine);
        sb.Draw(_pixel, new Rectangle(screen.X - 330, 10, 320, 74), new Color(12, 16, 34) * 0.85f);
        font.DrawText(sb, time, new Vector2(screen.X - 330 + (320 - timeSize.X) / 2, 16), Color.White);
        font.DrawText(sb, moonLine, new Vector2(screen.X - 330 + (320 - moonSize.X) / 2, 46), new Color(246, 236, 196));

        // bottom-right: stamina bar
        var barBack = new Rectangle(screen.X - 230, screen.Y - 40, 220, 22);
        sb.Draw(_pixel, barBack, new Color(12, 16, 34) * 0.85f);
        int fill = (int)(216 * (stamina.Current / stamina.Max));
        sb.Draw(_pixel, new Rectangle(barBack.X + 2, barBack.Y + 2, fill, 18),
            stamina.Current > 25 ? new Color(120, 200, 120) : new Color(210, 120, 90));
    }
}
```

- [ ] **Step 2: Wire clock/moon/stamina/HUD into GroveGame**

Add fields:

```csharp
private readonly GameClock _clock = new();
private readonly MoonCycle _moon = new();
private readonly Stamina _stamina = new(100f);
private Hud _hud = null!;
```

End of `LoadContent()`:

```csharp
_hud = new Hud(_pixel);
```

In `Update()` after `_player.Update(...)`:

```csharp
_clock.Advance(dt);
```

Replace `Draw()` with:

```csharp
protected override void Draw(GameTime gameTime)
{
    GraphicsDevice.Clear(new Color(10, 14, 28));

    _spriteBatch.Begin(samplerState: SamplerState.PointClamp, transformMatrix: CameraTransform());
    DrawLayer(_map.Layer("Back"));
    DrawLayer(_map.Layer("Buildings"));
    _spriteBatch.Draw(_pixel,
        new Rectangle((int)_player.Position.X - 6, (int)_player.Position.Y - 14, 12, 16),
        new Color(240, 235, 220));
    _spriteBatch.End();

    // night tint: darker when the moon is thinner (the moon's visible effect #2)
    var screen = new Point(_graphics.PreferredBackBufferWidth, _graphics.PreferredBackBufferHeight);
    _spriteBatch.Begin();
    float darkness = 0.55f * (1f - _moon.Brightness);
    _spriteBatch.Draw(_pixel, new Rectangle(0, 0, screen.X, screen.Y), new Color(8, 10, 30) * darkness);
    _hud.Draw(_spriteBatch, _clock, _moon, _stamina, screen);
    _spriteBatch.End();

    base.Draw(gameTime);
}
```

- [ ] **Step 3: Run and verify**

Expected: clock ticks visibly (6:00 PM onward), "Night 1 — New Moon" shown, world noticeably dark (new moon), stamina bar full.

- [ ] **Step 4: Commit** — `git add game && git commit -m "feat(game): HUD with clock, moon, stamina, and moon-driven night tint"`

---

### Task 11: Farming interactions

Tools: **1** hoe (till, 2 stamina) · **2** watering can (water, 1 stamina) · **3** seeds (plant, 1 stamina) · **E** harvest (free). Only inside the `farm fields` object rect. Acting on the tile the player faces.

**Files:**
- Create: `game/src/GhostLightGrove.Game/Farm.cs`
- Modify: `game/src/GhostLightGrove.Game/GroveGame.cs`

- [ ] **Step 1: Create Farm.cs**

```csharp
using GhostLightGrove.Core;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace GhostLightGrove.Game;

public sealed class Farm
{
    public static readonly CropDef Moonberry = new("Moonberry [PLACEHOLDER]", 3);

    public readonly Dictionary<Point, FarmPlot> Plots = new();
    private readonly Rectangle _bounds; // tile coords
    private readonly int _ts;

    public string? LastMessage { get; private set; }

    public Farm(TmxMap map)
    {
        _ts = map.TileWidth;
        var o = map.Objects.First(x => x.Name == "farm fields");
        _bounds = new Rectangle((int)(o.X / _ts), (int)(o.Y / _ts),
                                (int)(o.Width / _ts), (int)(o.Height / _ts));
    }

    private FarmPlot PlotAt(Point t) => Plots.TryGetValue(t, out var p) ? p : Plots[t] = new FarmPlot();

    public bool InBounds(Point t) => _bounds.Contains(t);

    public void Hoe(Point t, Stamina s)
    {
        if (!InBounds(t)) { LastMessage = "Can't till here."; return; }
        if (!s.TrySpend(2f)) { LastMessage = "Too tired..."; return; }
        LastMessage = PlotAt(t).Till() ? "Tilled." : "Already tilled.";
    }

    public void Water(Point t, Stamina s)
    {
        if (!InBounds(t)) return;
        if (!s.TrySpend(1f)) { LastMessage = "Too tired..."; return; }
        LastMessage = PlotAt(t).Water() ? "Watered." : "Nothing to water.";
    }

    public void Plant(Point t, Stamina s)
    {
        if (!InBounds(t)) return;
        if (!s.TrySpend(1f)) { LastMessage = "Too tired..."; return; }
        LastMessage = PlotAt(t).Plant(Moonberry) ? "Planted Moonberry. [PLACEHOLDER]" : "Needs tilled soil.";
    }

    public void Harvest(Point t)
    {
        if (!Plots.TryGetValue(t, out var p)) return;
        var got = p.Harvest();
        if (got != null) LastMessage = $"Harvested {got}!";
    }

    public void Draw(SpriteBatch sb, Texture2D pixel)
    {
        foreach (var (t, p) in Plots)
        {
            var rect = new Rectangle(t.X * _ts, t.Y * _ts, _ts, _ts);
            if (p.State == PlotState.Untilled) continue;
            sb.Draw(pixel, rect, (p.Watered ? new Color(70, 50, 35) : new Color(110, 80, 55)) * 0.9f);
            if (p.State == PlotState.Planted)
            {
                int h = p.IsMature ? 10 : 3 + p.GrowthNights * 2;
                var sprout = new Rectangle(rect.X + 6, rect.Bottom - 2 - h, 4, h);
                sb.Draw(pixel, sprout, p.IsMature ? new Color(235, 215, 120) : new Color(120, 200, 130));
            }
        }
    }
}
```

- [ ] **Step 2: Wire into GroveGame**

Add fields:

```csharp
private Farm _farm = null!;
private KeyboardState _prevKeys;
```

End of `LoadContent()`:

```csharp
_farm = new Farm(_map);
```

In `Update()` after `_clock.Advance(dt);`:

```csharp
bool Pressed(Keys k) => keys.IsKeyDown(k) && _prevKeys.IsKeyUp(k);
var target = _player.FacingTile;
if (Pressed(Keys.D1)) _farm.Hoe(target, _stamina);
if (Pressed(Keys.D2)) _farm.Water(target, _stamina);
if (Pressed(Keys.D3)) _farm.Plant(target, _stamina);
if (Pressed(Keys.E)) _farm.Harvest(target);
_prevKeys = keys;
```

In `Draw()` between `DrawLayer(...Back...)` and `DrawLayer(...Buildings...)`:

```csharp
_farm.Draw(_spriteBatch, _pixel);
```

In the HUD `Begin/End` block, after `_hud.Draw(...)`:

```csharp
if (_farm.LastMessage != null)
    _hud.Font(22).DrawText(_spriteBatch, _farm.LastMessage, new Vector2(16, screen.Y - 40), Color.White);
_hud.Font(20).DrawText(_spriteBatch,
    "1 Hoe   2 Water   3 Seeds   E Harvest   Enter Sleep (at dawn)", new Vector2(16, 12), new Color(180, 190, 220));
```

- [ ] **Step 3: Run and verify**

Expected: walk onto the farm rows, press 1/3/2 facing a tile → brown tilled square appears, sprout appears, watering darkens soil; stamina drains; harvest does nothing yet (crop not mature until nights pass).

- [ ] **Step 4: Commit** — `git add game && git commit -m "feat(game): farming interactions on the plateau field"`

---

### Task 12: Sleep, dusk report, new night

Sleep is allowed any time near the manor door (the spawn point) and is **forced at dawn** wherever you are. Sleeping advances the world via `NightSimulator`, restores stamina, resets the clock, and shows the dusk report.

**Files:**
- Modify: `game/src/GhostLightGrove.Game/GroveGame.cs`

- [ ] **Step 1: Add game-state machine and sleep flow**

Add field + enum at class level:

```csharp
private enum Mode { Playing, DuskReport }
private Mode _mode = Mode.Playing;
private DuskReport? _report;
private Vector2 _bedSpot; // manor door
```

In `LoadContent()` after `_player` creation:

```csharp
_bedSpot = _player.Position;
```

Wrap the gameplay part of `Update()` (player/clock/farm input) in `if (_mode == Mode.Playing) { ... }`, and add inside it:

```csharp
bool nearBed = Vector2.Distance(_player.Position, _bedSpot) < 28f;
if (_clock.IsDawn || (nearBed && Pressed(Keys.Enter)))
    Sleep();
```

Then add below `Update()`:

```csharp
private void Sleep()
{
    _report = NightSimulator.AdvanceNight(_farm.Plots.Values.ToList(), _moon);
    _stamina.RestoreFull();
    _clock.ResetToDusk();
    _player.Position = _bedSpot;
    _mode = Mode.DuskReport;
}
```

And handle dismissal at the top of `Update()`:

```csharp
if (_mode == Mode.DuskReport)
{
    var k = Keyboard.GetState();
    if (k.IsKeyDown(Keys.Enter) && _prevKeys.IsKeyUp(Keys.Enter)) _mode = Mode.Playing;
    _prevKeys = k;
    base.Update(gameTime);
    return;
}
```

- [ ] **Step 2: Draw the dusk report screen**

In `Draw()`, after the HUD block, add:

```csharp
if (_mode == Mode.DuskReport && _report != null)
{
    _spriteBatch.Begin();
    _spriteBatch.Draw(_pixel, new Rectangle(0, 0, screen.X, screen.Y), new Color(5, 7, 18) * 0.92f);
    var title = _hud.Font(40);
    title.DrawText(_spriteBatch, "DUSK REPORT", new Vector2(screen.X / 2f - 130, 120), new Color(246, 236, 196));
    var body = _hud.Font(26);
    for (int i = 0; i < _report.Lines.Count; i++)
        body.DrawText(_spriteBatch, "~  " + _report.Lines[i], new Vector2(screen.X / 2f - 240, 200 + i * 38), Color.White);
    body.DrawText(_spriteBatch, "[Enter] Begin the night", new Vector2(screen.X / 2f - 110, screen.Y - 120), new Color(180, 190, 220));
    _spriteBatch.End();
}
```

- [ ] **Step 3: Run and verify the full loop**

Expected: plant + water a few tiles → walk to the manor door → Enter → DUSK REPORT lists crop growth and tomorrow's moon → Enter → it's 6:00 PM, Night 2, stamina full, soil dry again. Repeat 3 nights → crop turns gold → E harvests it. Let the clock hit 6:00 AM → forced sleep. On Night 7 the report mentions the full moon, the world is visibly brighter, and watered crops jump 2 stages.

- [ ] **Step 4: Commit** — `git add game && git commit -m "feat(game): sleep loop, dusk report, night advancement"`

---

### Task 13: Wilcox (static tutorial NPC)

Static sprite near the manor door; E to talk; pages of dialogue. Lines below are canon-aligned but `[PLACEHOLDER]` — designer rewrites.

**Files:**
- Modify: `game/src/GhostLightGrove.Game/GroveGame.cs`

- [ ] **Step 1: Add Wilcox state and interaction**

Fields:

```csharp
private Vector2 _wilcoxPos;
private int _dialoguePage = -1; // -1 = closed
private static readonly string[] WilcoxLines =
{
    "Good evening. I am Wilcox, butler of this house. [PLACEHOLDER]",
    "That pendant... so it has come to you. Welcome home. [PLACEHOLDER]",
    "The field has gone untended. Tools: 1 to till, 3 to sow, 2 to water. Sleep before dawn. [PLACEHOLDER]",
};
```

In `LoadContent()` after `_bedSpot = ...`:

```csharp
_wilcoxPos = _bedSpot + new Vector2(36, 0);
```

In the `Mode.Playing` input section of `Update()` (before farm keys so E near Wilcox talks instead of harvests):

```csharp
bool nearWilcox = Vector2.Distance(_player.Position, _wilcoxPos) < 26f;
if (nearWilcox && Pressed(Keys.E))
{
    _dialoguePage = _dialoguePage >= WilcoxLines.Length - 1 ? -1 : _dialoguePage + 1;
}
else if (Pressed(Keys.E)) _farm.Harvest(target);
```

(Remove the previous standalone `if (Pressed(Keys.E)) _farm.Harvest(target);` line.)

- [ ] **Step 2: Draw Wilcox + dialogue box**

In world-space draw (after player rect):

```csharp
_spriteBatch.Draw(_pixel,
    new Rectangle((int)_wilcoxPos.X - 6, (int)_wilcoxPos.Y - 16, 12, 18),
    new Color(150, 160, 210) * 0.8f); // [PLACEHOLDER] ghost-grey
```

In the HUD block:

```csharp
if (_dialoguePage >= 0)
{
    var box = new Rectangle(screen.X / 2 - 350, screen.Y - 190, 700, 130);
    _spriteBatch.Draw(_pixel, box, new Color(12, 16, 34) * 0.95f);
    _hud.Font(24).DrawText(_spriteBatch, "WILCOX", new Vector2(box.X + 18, box.Y + 12), new Color(246, 236, 196));
    _hud.Font(24).DrawText(_spriteBatch, WilcoxLines[_dialoguePage], new Vector2(box.X + 18, box.Y + 48), Color.White);
    _hud.Font(20).DrawText(_spriteBatch, "[E] ...", new Vector2(box.Right - 70, box.Bottom - 30), new Color(180, 190, 220));
}
```

- [ ] **Step 3: Run and verify**

Expected: pale figure beside the manor door; E cycles three dialogue pages then closes; E elsewhere still harvests.

- [ ] **Step 4: Commit** — `git add game && git commit -m "feat(game): Wilcox static tutorial NPC with dialogue"`

---

### Task 14: Final verification — the One Perfect Night checklist

- [ ] **Step 1: Run full test suite**

Run: `dotnet test game/GhostLightGrove.sln`
Expected: all tests pass (≈24).

- [ ] **Step 2: Manual playthrough checklist** (run the game; check every box)

- [ ] Wake at dusk (6:00 PM) at the manor, Night 1, dark new-moon night
- [ ] Talk to Wilcox (3 pages)
- [ ] Till, plant, water at least 4 tiles; stamina visibly drains
- [ ] Sleep via Enter at manor door → dusk report shows growth + tomorrow's moon
- [ ] Crop matures after 3 watered nights → harvest with E
- [ ] Let the clock reach 6:00 AM → forced sleep works
- [ ] Reach Night 7 → report announces full moon, night is visibly brighter, watered crops grow ×2
- [ ] Walk down the cliff stairs through the graveyard to the town square and back (collision sane)
- [ ] Esc quits cleanly

- [ ] **Step 3: Fix anything that failed the checklist, then commit**

```powershell
git add -A
git commit -m "feat: One Perfect Night vertical slice complete"
```

---

## Out of Scope (deliberately — YAGNI)

Persistent saves · sound · real sprites/animation · NPC schedules · combat · reaper mechanics · tides · economy/shops · the dusk report's "world shifts" events beyond crops/moon (flavor line is a placeholder hook).
