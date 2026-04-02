---
layout: project
title: "Obsidian Note Bundler – Portable note export plugin"
description: "An Obsidian plugin that bundles notes with their linked notes and attachments into a portable folder or ZIP, walking the vault's link graph recursively."
image: "/assets/img/2025-04-02-obsidian-note-bundler/export-modal.png"
image_description: "Export modal of the Obsidian Note Bundler plugin showing configuration options."
date: 2025-04-02 10:00:00 +0200
read_time: 8
repo: https://github.com/JuanIsernGhosn/obsidian-note-bundler
---

**Obsidian Note Bundler** is a plugin for [Obsidian](https://obsidian.md) that lets you bundle any note together with all its linked notes and embedded attachments into a self-contained folder or ZIP file. The plugin walks your vault's **link graph** starting from the selected note, collecting every connected note and asset along the way.

I built this tool to solve a common problem: sharing a subset of an Obsidian vault without manually tracking down every linked file. Whether you're handing off a project to a colleague, archiving a research thread, or moving notes between vaults, Note Bundler does the heavy lifting.

---

## How it works

The core idea is simple: treat your vault as a **directed graph** where notes are nodes and `[[wikilinks]]` are edges. Starting from a root note, the plugin performs a breadth-first traversal up to a configurable depth (1–3 levels), collecting:

1. **Linked notes** — any note referenced via `[[wikilink]]` syntax
2. **Embedded assets** — files referenced via `![[embed]]` (images, PDFs, CSVs, etc.)
3. **Frontmatter references** — optionally, notes mentioned in YAML frontmatter properties

The result is a clean, portable bundle that preserves the relational structure of your notes.

---

## Key features

- **Recursive bundling** — follow links up to 3 levels deep, capturing the full context around a note
- **Batch export** — select multiple notes in the file explorer and bundle them all at once
- **Frontmatter link extraction** — optionally scan YAML properties for note references, with regex-based exclusion patterns
- **ZIP output** — package everything into a single `.zip` using JSZip (cross-platform, no CLI dependencies)
- **Multi-language UI** — English and Spanish, auto-detected from Obsidian's language settings
- **In-modal help** — a `?` button in the export modal explaining every option
- **Post-export summary** — file counts, missing references, and a quick "Open folder" button

---

## Architecture

The plugin is built with **TypeScript** and the Obsidian Plugin API. The codebase is intentionally small and focused:

```text
src/
├── main.ts            # Plugin entry: commands, ribbon icon, context menu, settings
├── export-engine.ts   # Core logic: link/asset extraction, graph traversal, bundling
├── export-modal.ts    # UI modals for single and batch exports
└── i18n.ts            # Internationalization (EN/ES)
```

The **export engine** is the heart of the plugin. It uses regex-based extraction to identify wikilinks and embeds, classifies files by extension (markdown → note, everything else → asset), and builds the bundle following a consistent structure:

```text
NoteName/
├── NoteName.md              # Root note
├── _assets/                 # Attachments from the root note
│   ├── image.png
│   └── document.pdf
└── _related/                # Linked notes (depth 1+)
    ├── LinkedNote1.md
    ├── LinkedNote2.md
    └── _assets/             # Attachments from linked notes
        └── diagram.svg
```

---

## The export modal

The plugin provides a clean modal interface where users can configure every aspect of the export before running it:

<p class="text-center">
  <img src="/assets/img/2025-04-02-obsidian-note-bundler/export-modal.png" width="70%" title="Export modal with configuration options">
</p>
<p class="text-center"><i>The export modal showing output path, depth, and asset options</i></p>

| Option | Default | Description |
| ------ | ------- | ----------- |
| Output folder | `~/Desktop` | Absolute path for the export |
| Output name | Note name | Name of the folder/ZIP |
| Related assets | ON | Include assets from linked notes |
| Frontmatter links | OFF | Include notes referenced in frontmatter |
| Exclude properties | *(empty)* | Regex to skip frontmatter properties |
| Depth | 1 | Recursion depth (1–3) |
| ZIP | OFF | Package as `.zip` instead of folder |

---

## Quick access

The plugin integrates naturally into Obsidian's UI through multiple entry points:

<p class="text-center">
  <img src="/assets/img/2025-04-02-obsidian-note-bundler/ribbon-icon.png" width="50%" title="Ribbon icon in the Obsidian sidebar">
</p>
<p class="text-center"><i>Ribbon icon for quick access from the sidebar</i></p>

- **Command palette**: `Cmd/Ctrl + P` → "Export Note"
- **Context menu**: right-click any `.md` file → "Export Note"
- **Batch mode**: select multiple files → right-click → "Export Notes (N)"
- **Ribbon icon**: one-click access from the sidebar

---

## Tech stack

- **TypeScript 5.8** with the Obsidian Plugin API
- **esbuild** for fast, single-file builds
- **JSZip** for cross-platform ZIP generation (replaced the initial macOS-only `zip` CLI approach)
- **Node.js `fs`** for writing bundles outside the vault (desktop-only requirement)

---

## Roadmap

The plugin is functional and stable at v1.0.0, with several features planned for future releases:

- **Backlinks** — include notes that link *to* the bundled note, not just outgoing links
- **Dataview queries** — extract note references from `dataview` / `dataviewjs` blocks
- **Canvas support** — bundle `.canvas` files and the notes they contain
- **Configurable folder structure** — customize `_related/` and `_assets/` directory names
- **Export templates** — transform note content during export (strip frontmatter, rewrite links, etc.)

---

> **Note Bundler** is open source under the MIT license. You can install it from [GitHub Releases](https://github.com/JuanIsernGhosn/obsidian-note-bundler/releases) or build it from source.
