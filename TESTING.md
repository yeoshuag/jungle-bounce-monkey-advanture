# Manual Test Checklist — Phase 1 (MVP)

This project was authored without access to a Godot editor/binary in the
build environment, so it has **not been opened or run yet**. Please run
through this checklist in Godot 4.x (4.2+) before trusting it.

## Setup

1. Open Godot 4.x, "Import" this project folder (select `project.godot`).
2. Let the editor finish importing (first import can take a minute).
3. Check the bottom output panel for any red script errors before running.

## Boot & navigation

- [ ] Run the project (F5). It should boot straight into a custom green
      splash screen with a procedurally-drawn monkey face and "Jungle
      Bounce" text — **no Godot logo/splash** should appear.
- [ ] After ~1.6s it should auto-transition to the Main Menu.
- [ ] Main Menu shows "Best: 0 m" on first run, a PLAY button, a QUIT button.
- [ ] PLAY loads the gameplay scene.

## Core gameplay

- [ ] Every run (first PLAY and every RETRY) always starts with a normal
      platform directly beneath the monkey — it should never appear to
      start mid-fall with nothing below it.
- [ ] The monkey auto-bounces continuously without any input.
- [ ] Dragging a finger (or holding + moving the mouse) left/right steers
      the monkey directly to the drag position (1:1 tracking, no lag/drift).
- [ ] Dragging past either screen edge stops the monkey right at the edge
      (clamped) — it never leaves the screen or wraps to the other side.
- [ ] The monkey lands on green (Normal), gold (Moving, drifts side to
      side), and platforms with a red coil on top (Spring, launches much
      higher) and bounces upward off each.
- [ ] Yellow crescent bananas appear near some platforms, bob gently, and
      disappear with a sound + HUD counter increase when touched.
- [ ] Collecting bananas in quick succession shows a "Combo xN" label that
      clears after ~2.5s of no collection.
- [ ] The altitude counter (top-left, in meters) only ever increases, and
      the camera only scrolls upward, never down.
- [ ] Platforms/bananas that scroll off the bottom of the screen stop
      being visible (open the Godot "Remote" scene tree at runtime while
      playing for ~30s and confirm the total node count under
      `PlatformGenerator` stays roughly constant — this validates pooling
      instead of unbounded node growth).
- [ ] Difficulty visibly ramps up with altitude (more moving/spring/breaking
      platforms, tighter gaps) the higher you climb.
- [ ] Brown platforms (Breaking) crack and darken the instant you bounce off
      them, then disappear about 0.3s later with a distinct sound — always
      *after* you've already bounced (never before/instead of the bounce).
- [ ] Occasionally a pair of spiked gray walls slides in from the left and
      right edges, holds closed for a moment, then retracts — repeating on a
      cycle. Touching a wall while extended ends the run the same way a fall
      does (respects an active Shield instead of always killing you).

## Pause / death / save loop

- [ ] Tapping the "II" button (top-right) pauses the game, dims the
      screen, and shows Resume / Mute / Main Menu.
- [ ] Mute silences all sound effects immediately; Unmute restores them.
- [ ] Resume returns to gameplay exactly where it left off.
- [ ] Falling off the bottom of the visible play area triggers Game Over,
      showing this run's altitude, bananas collected, and best altitude.
- [ ] RETRY starts a brand new run immediately (score/combo/platforms
      reset).
- [ ] MAIN MENU returns to the main menu.
- [ ] Close and reopen the project (or quit and relaunch a build): the
      Main Menu's "Best" value should persist from the previous session.
- [ ] Manually corrupt or delete the save file (find it via "Open User
      Data Folder" in the Project menu, edit `save.json` to invalid JSON
      or delete it) and relaunch — the game should start cleanly with
      default values instead of crashing.

## Upgrades

- [ ] Main Menu has an UPGRADES button below PLAY, opening a screen with 4
      rows: Jump Power, Banana Magnet, Shield Duration, Combo Bonus, each
      showing a level (Lv 0/5), a banana cost, and an UPGRADE button.
- [ ] With 0 bananas, all UPGRADE buttons are disabled; the button re-enables
      itself for a stat once you have enough banked bananas (play a run,
      collect bananas, return to Upgrades).
- [ ] Buying an upgrade deducts the shown cost, bumps that row's level, and
      updates the cost for the next level (or shows "MAX" at level 5/5).
- [ ] Jump Power level > 0: bounces are visibly higher than at level 0.
- [ ] Banana Magnet level > 0: bananas get collected automatically when the
      monkey passes near them without directly touching them; at level 0
      only direct contact collects them.
- [ ] Shield Duration level > 0: the monkey shows a translucent blue ring at
      the start of a run; falling off-screen during that window doesn't end
      the run (a rescue bounce + distinct sound plays and the ring
      disappears) — the rescued monkey actually survives and keeps playing
      (it should not die again immediately on the next frame) — after the
      shield window elapses (or after one save), falling ends the run
      normally.
- [ ] Combo Bonus level > 0: the combo label stays up longer than ~2.5s
      after your last banana before clearing.
- [ ] BACK returns to the Main Menu. Upgrade levels persist across app
      restart (same corrupt-save-file check as above should default
      upgrades to level 0 instead of crashing).

## Momentary powerup pickups

- [ ] Occasionally (rarer than bananas) a platform has a glowing orb instead
      of a banana: yellow-orange with two banana bumps (Double Bananas),
      orange with a white up-arrow (Double Jump), or blue with a white ring
      (Shield). It bobs like a banana and disappears with a distinct chime
      when touched.
- [ ] Double Bananas: for ~8s after pickup, a "2x BANANAS!" label shows near
      the top-left and banana values collected are doubled (stacks with
      combo multiplier); the label clears and doubling stops after ~8s.
- [ ] Double Jump: for ~8s after pickup, a "2x JUMP!" label shows and every
      bounce is visibly higher (multiplies on top of any Jump Power upgrade);
      reverts after ~8s.
- [ ] Shield pickup: grants/refreshes the same blue ring + rescue-bounce
      behavior as the Shield Duration upgrade's starting shield (picking one
      up mid-run when you don't already have a longer shield active should
      visibly add the ring if it wasn't already showing).
- [ ] Picking up a second Double Bananas/Double Jump while one is already
      active refreshes the timer rather than stacking to 4x/extending
      indefinitely.

## Performance sanity

- [ ] Use Debugger → Monitors → FPS while playing for a couple of minutes
      of continuous climbing; frame rate should stay stable (pooling
      means no growing allocation/GC pressure over a long run).

## Known Phase 1 scope limits (expected, not bugs)

- Only one biome (Jungle) and four platform types (Normal/Moving/Spring/
  Breaking) plus one hazard (Crusher Walls) exist. Cloud/Ice platforms,
  other biomes, enemies (bees/parrots/snakes), other environmental hazards
  (falling coconuts, fire, falling rocks), cosmetic shop (skins/hats/
  trails), missions, ads, and analytics are intentionally not implemented
  yet.
- Only 3 momentary powerup types exist (Double Bananas, Double Jump,
  Shield) — Banana Rain, Golden Monkey, Rocket Banana, and Slow Motion from
  the original spec are not implemented yet.
- No dedicated Settings screen yet — only a Mute toggle inside Pause.
