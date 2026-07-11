# Jungle Bounce: Monkey Adventure

A 2D endless vertical mobile platformer built in Godot 4.x (GDScript, free
tools only). The monkey auto-bounces upward forever; you steer left/right by
dragging. Collect bananas, chain combos, and climb as high as you can before
you fall.

## Status: Phase 1 (MVP)

This is the first of several planned phases. Phase 1 delivers a fully
playable core loop in a single biome (Jungle) so the architecture (pooling,
save system, procedural generation, UI flow) is proven before expanding
scope. Confirmed running on a real Android device via the debug APK built
by `.github/workflows/android-build.yml` (GitHub Actions → run → Artifacts).
See `TESTING.md` for the full manual test checklist.

Banana-funded stat upgrades (Jump Power, Banana Magnet, Shield Duration,
Combo Bonus) are implemented via an Upgrades screen off the Main Menu.
Momentary in-world powerup pickups (Double Bananas, Double Jump, Shield)
occasionally spawn on platforms and buff the run for a few seconds. A
Breaking platform type crumbles a moment after you bounce off it, and a
Crusher Walls hazard periodically squeezes in from both screen edges.

An altitude-based biome system (`autoload/BiomeManager.gd`) shifts the sky
color and platform tint through six biomes as you climb — Jungle, Temple,
Volcano, Night Forest, Cloud Kingdom, Space Jungle — with a name banner on
each transition. Four enemies (Bee, Snake, Parrot, Jungle Spirit) spawn
only in their matching biome(s) and behave as instant-death hazards (same
`"hazard"` group / shield-aware `die()` path as Crusher Walls).

Seven more platform types round out the mix: Ice (slippery landing),
Sticky (weak bounce), Golden (bonus bananas on landing), Cloud (drifts in
a 2D sine path), Secret (invisible until you get close), Treasure (rare,
single-use, big banana payout), and Swinging Vine (a pendulum-motion
platform — scoped down from a full grab/swing mechanic to fit the
existing bounce-on-contact architecture).

Planned next (Round B2, not yet built): remaining powerups (Rocket
Banana, Slow Motion, Golden Monkey, Banana Rain), rare collectibles
(Golden Banana, Treasure Chest, Ancient Idol, Magic Fruit), cosmetic
shop/skins, missions/achievements/daily rewards, ads + analytics
integration, and Google Play publishing materials.

## Android export

`export_presets.cfg` uses Godot's full Gradle build (`gradle_build/use_gradle_build=true`),
not the legacy/quick-test export — the legacy path was found to render the
game sideways on-device despite a correctly configured manifest, which is
a known limitation of that path. `.github/workflows/android-build.yml`
installs the Gradle build template headlessly (normally a GUI-only editor
action) by extracting `android_source.zip` from the installed export
templates and writing the matching `.build_version` marker itself.

## Requirements

- Godot 4.x (4.2 or newer), GL Compatibility or Mobile renderer.
- No external plugins, art, or audio assets — everything is generated
  procedurally in code (shapes drawn via `_draw()`, sound effects
  synthesized at runtime with `AudioStreamGenerator`).

## Running it

1. Open Godot 4.x → Import → select this folder's `project.godot`.
2. Press F5 (or run `scenes/Game.tscn` directly to skip the menu while
   iterating).

## Project layout

```
autoload/            GameManager, SaveManager, UpgradeManager, BiomeManager, AudioManager (singletons)
scenes/
  Splash.tscn         Custom boot splash (no Godot branding)
  MainMenu.tscn        Main menu
  Game.tscn            Gameplay root (camera, player, generator, HUD/pause/game-over)
  player/              Player controller + procedural monkey visual
  world/               Endless platform generator + pooled platform types,
                       hazards (world/hazards/), and enemies (world/enemies/)
  collectibles/        Banana pickup + momentary powerups (powerups/)
  ui/                  HUD, Pause menu, Game Over menu, Upgrades screen
```

## Controls

Drag anywhere on screen to steer horizontally. The monkey jumps
automatically on every platform landing — there is no jump button.
