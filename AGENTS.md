# Repository Guidelines

## Project Structure & Module Organization
- `Formula/` contains the Homebrew formula; `Formula/savant-context.rb` is the single source file to maintain.
- `savant-context-1.0.0.tar.gz` is the packaged release artifact referenced by the formula.
- `README.md` documents installation and usage for end users, and `LICENSE` tracks licensing.

## Build, Test, and Development Commands
- `brew install --build-from-source Formula/savant-context.rb`: builds and installs the formula locally for validation.
- `brew test savant-context`: runs the formula’s `test do` block to verify the CLI entry points.
- `brew audit --strict Formula/savant-context.rb`: checks formula style and metadata against Homebrew rules.
- `brew style Formula/savant-context.rb`: auto-formats and lint-checks the Ruby formula.

## Coding Style & Naming Conventions
- Ruby formula files use two-space indentation and Homebrew’s formula DSL; keep methods short and declarative.
- Name the class to match the formula (`class SavantContext < Formula`) and keep the filename kebab-cased (`savant-context.rb`).
- Prefer clear, literal strings for URLs, SHA256 hashes, and dependency names; avoid extra abstraction.

## Testing Guidelines
- There is no separate test suite; rely on the `test do` block in `Formula/savant-context.rb`.
- Keep tests lightweight and focused on command availability (e.g., `savant-context --version`).
- Run `brew test savant-context` after updating URLs, dependencies, or the tarball.

## Commit & Pull Request Guidelines
- Git history is not available in this workspace; use short, imperative commit subjects (e.g., "Update savant-context to v1.0.1").
- PRs should describe the version change, include the new SHA256, and note any dependency updates.
- Attach validation evidence (commands run and outputs) when changing the formula or release artifact.
