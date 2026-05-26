# 02 — Design system

The single source of truth for design tokens lives in `lib/core/theme/`.
Treat the values below as **documentation**; if you want to change them,
edit the Dart file, not this doc.

## Palette (dark theme)

| Token                | Value      | Use                          |
| -------------------- | ---------- | ---------------------------- |
| `AppColors.bg`       | `#080810`  | page background              |
| `AppColors.bgAlt`    | `#0F0F1A`  | section alt background       |
| `AppColors.surface`  | `#13131F`  | card solid surface           |
| `AppColors.glassBg`  | `rgba(255,255,255,0.05)` | glass card bg  |
| `AppColors.glassBorder` | `rgba(255,255,255,0.10)` | glass border |
| `AppColors.primary`  | `#6C63FF`  | violet — primary accent      |
| `AppColors.secondary`| `#00D9FF`  | cyan — secondary accent      |
| `AppColors.textPrimary`   | `#E8E8F0` | body text               |
| `AppColors.textSecondary` | `#8888AA` | muted text              |
| `AppColors.divider`  | `rgba(255,255,255,0.08)` | hairlines      |

### Gradients

- **Brand gradient:** `linear-gradient(135deg, #6C63FF, #00D9FF)`
  used on the name, section titles, and the typewriter cursor.

## Typography

| Token                       | Value                        |
| --------------------------- | ---------------------------- |
| `AppTypography.fontBody`    | `'Inter', sans-serif`        |
| `AppTypography.fontMono`    | `'JetBrains Mono', monospace`|
| `AppTypography.h1Size`      | `clamp(2.5rem, 6vw, 5rem)`   |
| `AppTypography.h2Size`      | `clamp(2rem, 4vw, 3rem)`     |
| `AppTypography.bodySize`    | `1rem`                       |
| `AppTypography.smallSize`   | `0.875rem`                   |

Fonts are loaded once via `@import` inside `core/theme/global_styles.dart`.

## Spacing scale (rem)

| Token                  | rem  | Use                          |
| ---------------------- | ---- | ---------------------------- |
| `AppSpacing.xs`        | 0.25 | gap inside a chip            |
| `AppSpacing.sm`        | 0.5  | tight gaps                   |
| `AppSpacing.md`        | 1    | default                      |
| `AppSpacing.lg`        | 1.5  | card padding                 |
| `AppSpacing.xl`        | 2.5  | between widgets              |
| `AppSpacing.section`   | 6    | vertical padding of a section|

## Radii

- `AppSpacing.radiusSm` = `8px` (badges)
- `AppSpacing.radiusMd` = `14px` (buttons, inputs)
- `AppSpacing.radiusLg` = `20px` (cards)

## Breakpoints (mobile-first)

| Name      | min-width |
| --------- | --------- |
| `sm`      | 480px     |
| `md`      | 768px     |
| `lg`      | 1024px    |
| `xl`      | 1280px    |

## Glass card recipe

```
background: var(--glass-bg);          /* rgba(255,255,255,0.05) */
border: 1px solid var(--glass-border);/* rgba(255,255,255,0.10) */
backdrop-filter: blur(10px);
border-radius: 20px;
padding: 1.5rem;
```

## Gradient text recipe

```
background: linear-gradient(135deg, #6C63FF, #00D9FF);
-webkit-background-clip: text;
background-clip: text;
color: transparent;
```

> All of the above is rendered through the type-safe Jaspr `StyleRule` API —
> see `docs/04-jaspr-cheatsheet.md`.
