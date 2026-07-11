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

Planned next phases (not yet built): more biomes, additional platform
types, enemies/hazards, powerups, shop/skins, missions/achievements/daily
rewards, ads + analytics integration, and Google Play publishing materials.

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
autoload/            GameManager, SaveManager, AudioManager (singletons)
scenes/
  Splash.tscn         Custom boot splash (no Godot branding)
  MainMenu.tscn        Main menu
  Game.tscn            Gameplay root (camera, player, generator, HUD/pause/game-over)
  player/              Player controller + procedural monkey visual
  world/               Endless platform generator + pooled platform types
  collectibles/        Banana pickup
  ui/                  HUD, Pause menu, Game Over menu
```

## Controls

Drag anywhere on screen to steer horizontally. The monkey jumps
automatically on every platform landing — there is no jump button.
