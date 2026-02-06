# Repository Guidelines

## Fork Focus & Knowledge Base
- This fork targets an AI-augmented DJ workflow, starting with Rekordbox‑style 4‑deck behavior parity.
- Personal research, design notes, and decisions live in `wiki/` (treat it as the local knowledge base for this fork).
- Next goal actionables are tracked in `wiki/IMPLEMENTATION_PLAN.md` (deck mapping toggle to use 4 decks with a 2‑deck Pioneer FLX4).

## Project Structure & Module Organization
- `src/`: Core C++/Qt application code (engine, UI, controllers, database, etc.).
- `src/test/`: GoogleTest-based unit tests (generally `*_test.cpp`).
- `res/`: Runtime assets (skins, QML in `res/qml/`, controller mappings in `res/controllers/`, images, translations).
- `cmake/`: CMake modules and helper scripts.
- `tools/`: Build and maintenance scripts (Python/shell; formatting helpers).
- `packaging/`: OS packaging resources (deb, wix, app metadata).
- `lib/`: Vendored/third‑party dependencies.

## Build, Test, and Development Commands
- Set up dependencies with the OS-specific build environment script, e.g.:
  - macOS: `source tools/macos_buildenv.sh setup`
  - Debian/Ubuntu: `tools/debian_buildenv.sh setup`
  - Windows: `tools\windows_buildenv.bat`
- Configure and build:
  ```sh
  mkdir build
  cd build
  cmake ..
  cmake --build .
  ```
- Run locally: `./mixxx` from the build directory.
- Tests (when `BUILD_TESTING` is enabled):
  ```sh
  ctest --output-on-failure
  # or run the binary directly
  ./mixxx-test
  ```
- Packaging: `cpack` from the build directory (optional).

## Coding Style & Naming Conventions
- Formatting is tool-driven: C++ uses `clang-format` (`.clang-format`), QML uses `qmlformat` (`.qmlformat.ini`), JS/TS uses `eslint` (`eslint.config.cjs`). Prefer running `pre-commit` hooks rather than manual reformatting.
- Follow existing naming patterns in each subsystem; new tests typically live in `src/test/` and follow `*_test.cpp`.
- Keep changes focused; avoid sweeping reformatting unless required.

## Testing Guidelines
- Framework: GoogleTest (configured in CMake when `BUILD_TESTING=ON`).
- Place new tests under `src/test/` and keep names descriptive and stable.
- Run the relevant tests locally before opening a PR; CI runs `ctest` in GitHub Actions.

## Commit & Pull Request Guidelines
- Commit messages should be concise, imperative, and wrapped at 72 characters. Examples from history include `refactor(engine): ...` and short, scoped summaries.
- Keep commits small and buildable; use topic branches per change.
- Avoid rebasing once review has started; prefer merge-based workflows.
- For UI changes, include before/after screenshots in the PR description.
- Describe what changed and how it was tested in the PR body.

## Configuration & Tooling Notes
- Install and enable `pre-commit` hooks (`pre-commit install` and `pre-commit install -t pre-push`) to enforce style, linting, and hygiene checks.
