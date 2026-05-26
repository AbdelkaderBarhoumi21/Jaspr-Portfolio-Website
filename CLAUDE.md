# CLAUDE.md — Project Memory

This file gives Claude Code persistent context for this repository.
Read it before making changes.

## Project

**Name:** `protfolio_website`
**Purpose:** Personal developer portfolio for **Barhoumi Abdelkader**
(Mobile Software Engineer — Flutter & Android, Tunis, Tunisia).
**Framework:** [Jaspr](https://jaspr.site) `^0.23.1` — modern Dart web framework.
**Render mode:** **Static (SSG)** — `jaspr.mode: static` in `pubspec.yaml`.
**Routing:** Single long-scroll page with anchor links (`#hero`, `#about`, …).
No multi-page navigation; `jaspr_router` is present but used minimally.

## Owner profile (used in copy)

- **Name:** Barhoumi Abdelkader
- **Role:** Mobile Software Engineer — Flutter & Android Developer
- **Email:** abdelkaderbarhoumi21@gmail.com
- **Phone:** +216 20 778 960
- **LinkedIn:** linkedin.com/in/barhoumi23176
- **GitHub:** github.com/AbdelkaderBarhoumi21
- **Languages:** Arabic (native), English B2, French B2

Full data lives in `lib/data/` — never hardcode profile facts inside section files.

## Architecture

Adapted Flutter Clean Architecture for a static site:

```
lib/
├── core/           ← theme, animations, constants, utils (cross-cutting)
├── data/           ← static content (profile, experience, projects, skills)
├── domain/models/  ← typed entities (Experience, Project, SkillGroup, …)
└── presentation/
    ├── layout/     ← AppLayout, Navbar, Footer
    ├── sections/   ← HeroSection, AboutSection, … (one per scroll anchor)
    └── widgets/    ← reusable: GlassCard, NeonButton, ProjectCard, …
```

**Rules:**
1. One component per file. No "kitchen sink" files.
2. `presentation/widgets/` must be reusable and content-agnostic
   (no hardcoded text from `data/`).
3. `presentation/sections/` consume `data/` and compose `widgets/`.
4. `domain/models/` are pure Dart — no `jaspr` imports.
5. Theme tokens (`core/theme/`) are the **only** source for colors, spacing,
   typography. Sections/widgets must reference them, not literal hex codes.

## Theme philosophy (Flutter-style)

Like Flutter's `Theme.of(context)`, we define design tokens **once** in
`core/theme/app_theme.dart` (with `app_colors.dart`, `app_typography.dart`,
`app_spacing.dart`) and import them everywhere. No prop drilling of colors.

- `AppColors.bg`, `AppColors.primary`, `AppColors.textPrimary`, …
- `AppTypography.h1Size`, `AppTypography.fontBody`, …
- `AppSpacing.section`, `AppSpacing.cardPad`, …

## Design system (summary — see `docs/02-design-system.md`)

- **Theme:** ultra-dark `#080810` background (not pure black).
- **Primary accent:** `#6C63FF` (violet)
- **Secondary accent:** `#00D9FF` (cyan)
- **Text primary:** `#E8E8F0` — **Text secondary:** `#8888AA`
- **Body font:** Inter — **Mono font:** JetBrains Mono (Google Fonts)
- **Glassmorphism cards:** `rgba(255,255,255,0.05)` bg + `1px solid rgba(255,255,255,0.1)` border + `backdrop-filter: blur(10px)`
- **Gradient text:** `linear-gradient(135deg, #6C63FF, #00D9FF)`

> Note: The user originally asked about "white and blue". The active palette is
> the dark/violet/cyan one above (final brief). If a future task says "go light
> mode," flip `AppColors` only — sections should not need edits.

## Animations (see `docs/03-animations.md`)

- Scroll-triggered fade-up / slide-in via `IntersectionObserver` (vanilla JS
  injected via `<script>` in `Document` or a `RawText` component).
- Typewriter effect on hero job title (cycles: Flutter Developer, Android
  Engineer, Mobile Architect, IoT Specialist).
- Navbar becomes solid + blurred on scroll (`backdrop-filter`).
- ScrollSpy highlights the active section in the navbar.
- Project cards: 3D tilt on hover (CSS `perspective` + JS mousemove).
- Custom cursor dot following the mouse with lag.
- All easing uses `cubic-bezier(0.22, 1, 0.36, 1)`.

## Jaspr conventions used here

- Components default to `StatelessComponent`.
- Use `@client` only on components that need browser-side JS state
  (e.g. mobile nav toggle). Most of this site is static HTML.
- Use `@css` on a `static List<StyleRule> get styles` getter to ship
  type-safe CSS bundled with the component.
- Use `dom.dart` HTML primitives (`div`, `section`, `h1`, …) — not Flutter
  widgets.
- Anchor scrolling: each section is a `<section id="...">`; the navbar uses
  plain `<a href="#...">` links plus CSS `scroll-behavior: smooth`.

## Commands

```bash
# dev server (hot reload)
jaspr serve

# static build → build/jaspr/
jaspr build
```

## What NOT to do

- ❌ Do not embed Flutter Web — this is pure Jaspr.
- ❌ Do not add Tailwind — styling stays in Dart via `StyleRule`.
- ❌ Do not hardcode colors/fonts inside sections — use `core/theme/`.
- ❌ Do not duplicate content between `data/` and section files.
- ❌ Do not invent new sections without updating the navbar and ScrollSpy.

## Where to look first

- New feature?  → `docs/01-architecture.md`
- New color/font?  → `lib/core/theme/`
- New animation?  → `docs/03-animations.md` + `lib/core/animations/`
- Jaspr syntax reminder?  → `docs/04-jaspr-cheatsheet.md`
- Content edit?  → `lib/data/`
