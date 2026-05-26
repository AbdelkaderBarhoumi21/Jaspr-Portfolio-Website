# Portfolio — Barhoumi Abdelkader

Personal developer portfolio built with [Jaspr](https://jaspr.site) (Dart
web framework) in **static (SSG)** mode. Single long-scroll page with
anchor sections, scroll-triggered animations, a typewriter hero, 3D
project-card tilt, and a custom cursor.

## Stack

- **Jaspr** `^0.23.1` — static rendering
- **Pure Dart** for everything (no Tailwind, no Flutter Web embedding)
- Type-safe CSS via Jaspr `StyleRule`
- Vanilla JS for IntersectionObserver / typewriter / ScrollSpy / 3D tilt /
  custom cursor (injected once via `Document(head: [script(...)])`)

## Run

```bash
# dev server with hot reload — http://localhost:8080
jaspr serve

# static build — outputs to build/jaspr/
jaspr build
```

### Production build with sitemap

When deploying, pass your real domain so Jaspr generates `sitemap.xml`:

```bash
jaspr build --sitemap-domain https://abdelkaderbarhoumi.dev
```

Also remember to:

- Drop `web/cv/Mobile_Abdelkader_Barhoumi_CV.pdf` for the Download CV button.
- Drop `web/images/og-card.png` (1200×630) for social link previews.
- Update `_siteUrl` in `lib/main.server.dart` if the domain isn't the one above.

### After deleting or renaming `@client` components

Regenerate the Jaspr builder options:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Project layout

```text
lib/
├── core/                       cross-cutting (no UI knowledge)
│   ├── theme/                  AppColors, AppTypography, AppSpacing, global_styles
│   ├── animations/             reveal/typewriter/tilt CSS + injected JS
│   ├── constants/              AppAnchors, AppAssets
│   └── utils/
├── data/                       static content from the CV
│   ├── profile_data.dart
│   ├── experience_data.dart
│   ├── projects_data.dart
│   └── skills_data.dart
├── domain/models/              pure-Dart entities (Experience, Project, …)
└── presentation/
    ├── layout/                 AppLayout, Navbar (+ @client MobileNavToggle), Footer
    ├── sections/               HeroSection, AboutSection, … one per scroll anchor
    └── widgets/                reusable: GlassCard, NeonButton, SkillBadge,
                                ProjectCard, TimelineItem, SocialIcon, …
```

Documentation lives in [`docs/`](docs/) — architecture, design system,
animations, Jaspr cheatsheet, and content-data reference. Project memory
for Claude Code is in [`CLAUDE.md`](CLAUDE.md), and the agent + skill
configuration is in [`.claude/`](.claude/).

## Adding content

- New job → edit `lib/data/experience_data.dart`.
- New project → edit `lib/data/projects_data.dart`.
- New skill → edit `lib/data/skills_data.dart`.
- Profile / contact info → edit `lib/data/profile_data.dart`.

Section files **do not** hardcode personal copy — they iterate the data
files above.

## Theming

All design tokens live in `lib/core/theme/`. To re-skin the site, edit
`app_colors.dart` / `app_typography.dart` / `app_spacing.dart`. Sections
and widgets reference these constants exclusively — there are no literal
hex codes in the section/widget code.

## License

Personal portfolio — code is for reference; please don't reuse the
content verbatim.
