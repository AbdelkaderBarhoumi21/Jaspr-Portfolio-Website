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

### Deploy to GitHub Pages

The repo ships a workflow at `.github/workflows/deploy.yml` that builds
the site and publishes it to GitHub Pages on every push to `main`.

**One-time setup** (do this once in the GitHub UI):

1. Repo → **Settings → Pages → Source: "GitHub Actions"** (not "Deploy from a branch").
2. Push the workflow file to `main` (the first push to `main` after that triggers a deploy).

After ~2 minutes, the site is live at:

> <https://abdelkaderbarhoumi21.github.io/portfolio/>

**How the subpath works.** GitHub Pages hosts project sites under
`/<repo-name>/`, so `index.html` and every asset must use that as a base.
The workflow passes `BASE_HREF=/portfolio/` to the build via
`--dart-define-server`, which `lib/main.server.dart` reads at SSG time
and passes to `Document(base: ...)`. Local `jaspr serve` is unaffected
(no env var → defaults to `/`).

**Custom domain.** If you later buy a domain (e.g. `abdelkaderbarhoumi.dev`):

1. Add a `CNAME` file to `web/` containing the domain.
2. Configure DNS at your registrar.
3. Repo → **Settings → Pages → Custom domain** → enter the domain.
4. Edit `.github/workflows/deploy.yml`: change `BASE_HREF` to `/` and
   `SITE_URL` to your domain.

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
