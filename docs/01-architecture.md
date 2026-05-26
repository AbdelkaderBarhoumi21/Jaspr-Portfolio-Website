# 01 — Architecture

This portfolio uses **Jaspr** (Dart web framework) in **static (SSG) mode**
with the folder structure adapted from Flutter's clean architecture.

## Layer overview

```
lib/
├── main.server.dart          ← server entrypoint (renders HTML at build time)
├── main.client.dart          ← client entrypoint (hydrates @client components)
├── app.dart                  ← root <App> component
│
├── core/                     ← cross-cutting, no business knowledge
│   ├── theme/                ← THE theme (single source of design tokens)
│   ├── animations/           ← reusable keyframes + IO scripts
│   ├── constants/            ← asset paths, anchor IDs
│   └── utils/                ← small helpers
│
├── data/                     ← static "repository" — content the site renders
│
├── domain/models/            ← pure typed models (no Jaspr imports)
│
└── presentation/             ← UI layer
    ├── layout/               ← AppLayout, Navbar, Footer
    ├── sections/             ← one component per scroll anchor
    └── widgets/              ← small reusable components
```

## Mapping vs. Flutter clean architecture

| Flutter (mobile)               | This Jaspr site                     |
| ------------------------------ | ----------------------------------- |
| `core/theme/` ThemeData        | `core/theme/app_theme.dart` (+ tokens) |
| `data/repositories/`           | `data/*.dart` (static lists)        |
| `domain/entities/`             | `domain/models/`                    |
| `presentation/screens/`        | `presentation/sections/`            |
| `presentation/widgets/`        | `presentation/widgets/`             |
| `main.dart`                    | `main.server.dart` + `main.client.dart` |

## Data flow

```
data/*.dart ──→ domain/models/* ──→ presentation/sections/* ──→ widgets/*
                                          ▲
                          core/theme + core/animations
```

- Sections **never** hardcode profile content. They import from `data/`.
- Widgets **never** import from `data/`. They take typed `domain/models/`
  via constructor parameters — exactly like a Flutter `Widget`.
- `core/theme/*` is imported anywhere it's needed, but the values are
  defined in exactly **one** place per concern (colors, typography, spacing).

## File-naming convention

| Kind                  | Pattern                                  |
| --------------------- | ---------------------------------------- |
| Class                 | `PascalCase`                             |
| File                  | `snake_case_of_the_class.dart`           |
| Section               | `*_section.dart` (`hero_section.dart`)   |
| Reusable widget       | descriptive noun (`glass_card.dart`)     |
| Model                 | singular noun (`project.dart`)           |
| Data list             | `*_data.dart` (`projects_data.dart`)     |

## Adding a new section — checklist

1. Add a typed model in `domain/models/` if the section needs structured
   data.
2. Add the data list in `data/`.
3. Create the section file in `presentation/sections/`, importing the data
   and composing widgets.
4. Register the section in `app.dart` (insert it into the scroll order).
5. Add the anchor ID to the Navbar and ScrollSpy in
   `presentation/layout/navbar.dart`.
6. Add the anchor constant to `core/constants/app_anchors.dart`.

## Static mode notes

- `jaspr build` outputs plain HTML/CSS/JS to `build/jaspr/`.
- Any component that genuinely needs JS state must be marked `@client`.
- Everything else is rendered at build time and shipped as static HTML —
  great SEO, fast first paint, near-zero JS for most sections.
