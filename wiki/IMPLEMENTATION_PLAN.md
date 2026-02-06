# Mixx FLX4 Rekordbox-Style Revamp Plan

## Goals
- Replicate Rekordbox-style behavior for FX handling and MIDI controls mapping using a Pioneer FLX4.
- Replace the SmartFX button with a 4-deck toggle:
  - SmartFX: toggle Deck 1 ↔ Deck 3
  - Shift + SmartFX: toggle Deck 2 ↔ Deck 4
- Ensure all controls (jog, transport, EQ, filters, FX, etc.) reroute to the active deck pair.
- Keep hardware LEDs optional for now.

## Assumptions & Constraints
- Start from Mixx’s **default FLX4 mapping** (no custom mapping exists yet).
- The hardware has **two physical decks** but must control **four Mixx decks** via toggling.
- FX should work **per deck**, and be controllable with knobs and beat-step arrows.
- Mixx controller mappings are typically implemented in JS + XML (Mixxx Controller Mapping System).

## Scope
### In-Scope
- Deck switching logic (1↔3, 2↔4).
- Rerouting all controls to the active deck.
- FX routing and parameters per deck.
- Mapping test/validation steps before/after modifications.

### Out-of-Scope (for now)
- LED state mirroring for deck toggles.
- Rekordbox UI feature parity beyond mapping behavior.

## Functional Design
### Deck Toggle State Model
- `leftDeck = 1 | 3` (physical left deck controls these)
- `rightDeck = 2 | 4` (physical right deck controls these)

### Button Mapping
- **SmartFX (no shift):** toggles `leftDeck` between 1 and 3.
- **Shift + SmartFX:** toggles `rightDeck` between 2 and 4.

### Control Routing
All physical controls must route dynamically to the current logical deck:
- Jog wheel
- Transport (play/cue/sync)
- Pitch/tempo
- EQ and filters
- FX enable + FX knobs
- Beat parameter steps (left/right arrows)

## FX Handling Strategy
### Desired Behavior
- FX are applied independently per deck.
- FX level (depth) is controlled by the FLX4 physical knobs.
- FX parameter variation is controlled by beat step arrows.
- FX enable/disable follows the active deck selection.

### Mixx Mapping Translation
- Map FX on/off to the currently active deck rack.
- Map FX parameter knob to the deck’s effect unit.
- Map beat-step arrows to effect parameter stepping on the active deck.

## Implementation Steps
1. **Locate default FLX4 mapping** (XML + JS) from Mixx installation or official mappings repo.
2. **Create custom mapping** in this project to avoid editing the default file.
3. **Introduce deck toggle state** variables in the JS mapping layer.
4. **Wrap deck-specific controls** to resolve the target deck dynamically.
5. **Update FX control bindings** to follow the active deck state.
6. **Create a regression checklist** to confirm no base controls broke.

## Test Plan
### Before Changes (Baseline)
- Verify current default FLX4 mapping behavior in Mixx:
  - Deck 1/2 controls work as expected.
  - SmartFX performs its default behavior.
  - FX knobs and beat-step arrows affect FX on the assigned decks.

### After Changes (Regression + New Functionality)
- **Deck toggle validation**
  - SmartFX toggles Deck 1 ↔ 3.
  - Shift + SmartFX toggles Deck 2 ↔ 4.
- **Control rerouting validation**
  - Jog, transport, EQ, filters, pitch follow the toggled deck.
  - FX enable/disable targets the active deck.
  - FX depth knob controls the active deck effect level.
  - Beat-step arrows modify the active deck FX parameters.
- **Stability checks**
  - Rapid toggling does not break deck assignments.
  - Shift state does not interfere with non-deck-toggle mappings.

## Deliverables
- Custom FLX4 mapping (XML + JS) implementing deck toggles and FX routing.
- Documentation of mapping behavior and test checklist.

## Open Questions / Follow-Ups
- Do you want visual LED indication for deck 3/4 mode in a later iteration?
- Should a long-press on SmartFX reset both sides to Deck 1/2?
- Should deck toggle state persist across Mixx restarts?