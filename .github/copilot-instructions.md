# Copilot Instructions for this repository

## Big picture
- This repo contains **two Safari extension implementations** of the same behavior:
  - `Select Like A Boss For Safari/` is the modern Safari App Extension (Xcode project).
  - `Legacy Safari Extension/` is the old `.safariextz` package format.
- Core product behavior is in injected JavaScript that enables text selection inside links. Swift files are mostly host/integration glue.

## Architecture and data flow
- Content script entrypoint for modern extension: `Select Like A Boss For Safari/Select Like A Boss/script.js`.
- Legacy content script entrypoint: `Legacy Safari Extension/end.js`.
- `script.js` and `end.js` are currently near-identical; when changing selection behavior, update both unless intentionally dropping legacy parity.
- Injection is declared in extension plist: `Select Like A Boss For Safari/Select Like A Boss/Info.plist` under `NSExtension -> SFSafariContentScript`.
- Swift extension host class: `Select Like A Boss For Safari/Select Like A Boss/SafariExtensionHandler.swift`.
  - It currently only logs events (`messageReceived`, toolbar callbacks) and returns the popover VC.
- Containing macOS app exists to host/enable extension and open Safari preferences:
  - `Select Like A Boss For Safari/Select Like A Boss For Safari/ViewController.swift`.

## Critical coupling to preserve
- `showPreferencesForExtension(withIdentifier:)` in `ViewController.swift` must match the extension bundle id.
- The extension bundle id is defined in Xcode build settings (`project.pbxproj`) as:
  - `me.spaceinbox.Select-Like-A-Boss-For-Safari.Select-Like-A-Boss`.
- If bundle identifiers change, update both build settings and this hardcoded identifier.

## Developer workflows
- Open/build from Xcode project:
  - `Select Like A Boss For Safari/Select Like A Boss For Safari.xcodeproj`
- CLI discovery command that works in this repo:
  - `xcodebuild -list -project "Select Like A Boss For Safari/Select Like A Boss For Safari.xcodeproj"`
- Main scheme: `Select Like A Boss For Safari` (builds app + embedded extension target `Select Like A Boss`).
- There are no automated tests in the repository; validate by running the app/extension in Safari and testing selection/drag behavior on link-heavy pages.

## Project-specific coding patterns
- JS behavior is intentionally implemented as a self-contained IIFE with function-scoped `var` and explicit event bind/unbind lifecycle.
- Selection-vs-drag decision is based on horizontal/vertical motion thresholds (`D`, `K`) in the content script; preserve this logic shape when refactoring.
- The script uses capture-phase document listeners for mouse/drag/click coordination; avoid changing listener phase unless required.

## Legacy release artifacts
- Top-level `select-like-a-boss-for-safari.safariextz` and `update.plist` are legacy distribution artifacts.
- If making a modern-only fix, do not modify legacy packaging files.
- If making a behavior fix intended for legacy users, keep `Legacy Safari Extension/Info.plist` metadata/versioning aligned with artifact updates.

## Scope guidance for AI agents
- Prefer minimal, surgical edits in `script.js` for behavior changes.
- Avoid adding dependencies/build systems (npm, SwiftPM) unless explicitly requested.
- Keep comments/license headers intact in JS files derived from original upstream code.
