---
name: jaspr-component
description: Scaffold a new Jaspr component (StatelessComponent or @client StatefulComponent) following this project's clean-architecture conventions. Use whenever the user asks to "create a section / card / widget / button" in Dart with Jaspr.
---

# Skill — Scaffold a Jaspr component

## When to use

Any request like "make a `ProjectCard` widget", "add a `SkillBadge`", "create
the experience section component", etc.

## Decision tree

1. **Does it hold any browser-only state** (toggle, mouse position, timer)?
   - Yes → `@client class X extends StatefulComponent`.
   - No  → `class X extends StatelessComponent` (default).
2. **Where does it live?**
   - Reusable, content-agnostic   → `lib/presentation/widgets/`
   - Top-level scroll section     → `lib/presentation/sections/`
   - Layout chrome (nav, footer)  → `lib/presentation/layout/`
3. **Does it need new design tokens** (color, spacing, font size)?
   - Yes → add to `lib/core/theme/app_colors.dart` etc. **first**.
4. **Does it need new content**?
   - Yes → add to the right `lib/data/*.dart` file. Never hardcode copy.

## Template — StatelessComponent

```dart
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class GlassCard extends StatelessComponent {
  const GlassCard({required this.children, super.key});

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return div(classes: 'glass-card', children);
  }

  @css
  static List<StyleRule> get styles => [
    css('.glass-card').styles(
      padding: .all(AppSpacing.cardPad.px),
      backgroundColor: AppColors.glassBg,
      // …more tokens, never raw hex
    ),
  ];
}
```

## Template — @client StatefulComponent

Only when client-side state is required.

```dart
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

@client
class MobileNavToggle extends StatefulComponent {
  const MobileNavToggle({super.key});

  @override
  State<MobileNavToggle> createState() => _MobileNavToggleState();
}

class _MobileNavToggleState extends State<MobileNavToggle> {
  bool _open = false;

  @override
  Component build(BuildContext context) {
    return button(
      classes: _open ? 'nav-toggle is-open' : 'nav-toggle',
      onClick: () => setState(() => _open = !_open),
      [span([]), span([]), span([])],
    );
  }
}
```

## Hard rules

- One component per file. File name = `snake_case_of_class.dart`.
- Use `dom.dart` HTML helpers (`div`, `section`, `button`, `a`, …).
- Reference design tokens from `core/theme/` — **never** literal `#hex`.
- Co-locate styles via `@css static List<StyleRule> get styles`.
- For animations, add a class from `core/animations/animation_styles.dart`
  (e.g. `reveal-up`); do not write keyframes per-component.
