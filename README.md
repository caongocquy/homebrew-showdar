# Homebrew Showdar

Homebrew tap for Showdar CLI tools.

## Install

Install directly:

```bash
brew install caongocquy/showdar/code-atlas
brew install caongocquy/showdar/showdar-skills
brew install caongocquy/showdar/showdar-router
```

Or tap once:

```bash
brew tap caongocquy/showdar
brew install code-atlas
brew install showdar-skills
brew install showdar-router
```

The formulas install the macOS platform bundle published in each project's GitHub Release and use Homebrew's `node@24` runtime. Current release bundles target macOS 15 or newer.

## Packages

- [Code Atlas](https://github.com/caongocquy/code-atlas)
- [Showdar Skills](https://github.com/caongocquy/showdar-skills)
- [Showdar Router](https://github.com/caongocquy/showdar-router)

Each project also publishes Linux x64 and Windows x64 archives to GitHub Releases. Windows users can continue installing from npm or download the release archive directly.

## Release flow

A tagged release builds native platform bundles:

```text
<tool>-darwin-arm64.tar.gz
<tool>-darwin-x64.tar.gz
<tool>-linux-x64.tar.gz
<tool>-windows-x64.zip
```

Each archive is accompanied by a `.sha256` file.

`scripts/sync-formulas.mjs` reads the latest stable GitHub Releases and updates `Formula/*.rb` when both macOS assets are available. The sync workflow runs hourly and can also be triggered manually.
