# Mixxx Skins: How They Work and How to Build Them

## Overview
Mixxx supports two skin systems that can coexist in the same build:

1) **QML-based skins (modern UI)**
   - UI is built with QML files in `res/qml/`.
   - Styling is centralized in `res/qml/Theme/Theme.qml` and shared QML components in `res/qml/`.
   - Best for new development: dynamic layouts, state-driven visuals, and richer UI behavior.

2) **Legacy XML + QSS skins**
   - Skins live under `res/skins/<SkinName>/` with a `skin.xml` manifest and QSS styling.
   - Still supported and widely used (e.g., LateNight, Deere).
   - Ideal for static layouts and incremental changes to existing classic skins.

This document covers both systems and how to build new skins in this repo.

---

## What Skins Are
A Mixxx skin defines **what the UI looks like** and **where controls are**. Skins do **not** implement audio DSP or MIDI/controller logic — they only render UI and bind UI elements to Mixxx controls.

Skins typically specify:
- Layout of decks, mixers, library, FX racks, samplers, and panels
- Visual styling (colors, fonts, images, borders)
- Which controls appear and how they respond to engine state
- Optional configuration defaults (e.g., show/hide panels)

Skins bind to Mixxx engine controls via control groups like `[Channel1]`, `[Master]`, `[EffectRack1_EffectUnit1]`, etc.

---

## What You Can Do with Skins

### QML Skins (res/qml)
QML skins can:
- Compose complex layouts with `Row`, `Column`, `Grid`, custom components
- Bind properties to Mixxx engine state via `Mixxx.ControlProxy`
- Add subtle animations, transitions, and state-driven styles
- Use shared theme values from `Theme.qml` for consistent look
- Create reusable UI components (buttons, knobs, meters) in `res/qml/` and `res/qml/Deck/`
- Add UI-only indicators and overlays driven by custom controls (e.g., deck-active outline)

Examples in this repo:
- `res/qml/Deck.qml` builds deck layout from reusable components.
- `res/qml/Theme/Theme.qml` defines global colors, image assets, and font choices.

### Legacy XML + QSS Skins (res/skins)
Legacy skins can:
- Define a full layout in XML (see `res/skins/LateNight (64 Samplers)/skin.xml`)
- Provide persistent skin settings via `<attribute config_key="[Skin],...">`
- Use QSS files to style widgets (`style.qss`, `style_classic.qss`, etc.)
- Reference SVG/PNG assets for buttons, borders, backgrounds

Examples in this repo:
- `res/skins/LateNight (64 Samplers)/skin.xml` defines defaults and configuration keys
- `res/skins/Deere/style.qss` contains extensive widget styling

---

## What You Can’t Do with Skins
Skins are **UI-only**. They cannot:
- Change audio engine behavior, DSP, or internal timing
- Add new engine controls not already provided by Mixxx
- Override controller mappings (that’s done in `res/controllers/`)
- Run arbitrary background services or external processes
- Persist new data beyond existing control/state systems

QML skins do allow richer UI logic, but they still only interact with Mixxx through exposed controls and properties.

---

## How to Build Skins

### Option A: Build a QML Skin (recommended for new work)

**1) Start from existing QML components**
- Browse `res/qml/` and `res/qml/Deck/` to see how components are built.
- Reuse shared UI pieces (buttons, knobs, meters) instead of reinventing them.

**2) Use the Theme**
- Centralize colors, fonts, and images in `res/qml/Theme/Theme.qml`.
- Reference theme values in your QML for consistency.

**3) Bind to Mixxx controls**
- Use `Mixxx.ControlProxy` to bind UI state to engine values:
  - Example: `group: root.group`, `key: "play"` or `"track_loaded"`.
- Keep group strings consistent with Mixxx control group naming.

**4) Compose layout**
- Use `LayoutItem`, `Row`, `Column`, and custom components.
- See `res/qml/Deck.qml` for a large, real example.

**5) Test and iterate**
- Restart Mixxx or reload the skin to apply QML changes.
- Keep changes focused and verify layout at different window sizes.

**Best practices**
- Use QML components for reusability and clarity.
- Keep logic UI-only; push engine logic to controllers or C++ if needed.
- Prefer theme variables over hard-coded values.

### Option B: Build a Legacy XML + QSS Skin

**1) Pick a base skin**
- Copy a directory in `res/skins/` and rename it.
- Update `skin.xml` manifest (`<title>`, `<author>`, `<version>`, etc.).

**2) Define defaults and settings**
- Add `<attribute config_key="[Skin],...">` entries in `skin.xml`.
- These can drive UI toggles (show/hide panels, deck modes, etc.).

**3) Edit layout XML**
- Layout and widgets are defined in XML (see `skin.xml` and helper templates).
- Use `<Template>` includes for reusable components.

**4) Style with QSS**
- Adjust colors, borders, fonts, and images in `style.qss`.
- Use SVG assets for scalable UI elements.

**5) Test**
- Switch to your skin in Mixxx preferences.
- Restart Mixxx if resources do not refresh properly.

---

## Practical Notes for This Repo

- QML skins live in `res/qml/`.
- Theme values live in `res/qml/Theme/Theme.qml`.
- Legacy skins live in `res/skins/` with `skin.xml` and QSS files.
- Custom UI tweaks (like deck outline indicators) should be implemented in QML if you want them to be dynamic.
- If you add new controls in controller scripts and want UI feedback, create a matching `Mixxx.ControlProxy` binding in QML.

---

## Suggested Workflow for New Skins

1) Decide system:
   - QML for modern/dynamic UI
   - XML+QSS only if extending legacy skins
2) Fork a baseline skin (copy existing QML components or a full legacy skin directory)
3) Define a theme palette and reuse it consistently
4) Implement layout incrementally
5) Bind to Mixxx controls and verify behavior
6) Iterate on performance and readability

---

## Troubleshooting

- **Changes don’t appear**: restart Mixxx or reload the skin.
- **Controls not updating**: verify `group` and `key` names match Mixxx controls.
- **Performance issues**: reduce heavy animations, avoid excessive timers, simplify bindings.
- **Legacy skin bugs**: ensure all XML templates resolve and QSS paths are valid.

