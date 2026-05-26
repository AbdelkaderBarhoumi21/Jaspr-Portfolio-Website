---
name: jaspr-style
description: Write or update CSS in this Jaspr project using the type-safe `StyleRule` API. Use whenever the user asks to tweak spacing, colors, layout, hover states, or media queries on a Jaspr component.
---

# Skill — Write Jaspr styles the right way

## The rule

CSS in this project is **always** written as Dart `StyleRule` objects via the
`css(...)` helper, co-located with the component via `@css static get styles`.

```dart
@css
static List<StyleRule> get styles => [
  css('.hero', [
    css('&').styles(
      padding: .symmetric(vertical: 4.rem),
      backgroundColor: AppColors.bg,
    ),
    css('&:hover').styles(opacity: 0.9),
    css('h1').styles(
      fontSize: 4.rem,
      color: AppColors.textPrimary,
    ),
  ]),
];
```

## Patterns to know

- `.styles(...)` takes type-safe properties (`padding`, `color`,
  `fontSize`, …). Use `.all(8.px)`, `.symmetric(horizontal: 2.rem)`,
  `.only(top: 1.em)` for shorthand.
- Pseudo-selectors: `css('&:hover')`, `css('&::before')`.
- Nesting: pass a `List<StyleRule>` as the second arg to `css(...)`.
- Media queries:
  ```dart
  css('@media (max-width: 768px)', [
    css('.hero h1').styles(fontSize: 2.5.rem),
  ]),
  ```
- Keyframes: use the raw-string escape only when necessary — keep them in
  `core/animations/animation_styles.dart`.

## Where styles live

| Scope                       | Where                                                |
| --------------------------- | ---------------------------------------------------- |
| Global reset, body, fonts   | `lib/core/theme/global_styles.dart` (@css getter)    |
| Reusable animation classes  | `lib/core/animations/animation_styles.dart`          |
| Component-specific          | Inside the component file, `@css static get styles`  |

## Hard rules

- ❌ No inline `style="..."` strings on elements.
- ❌ No literal hex codes — pull from `core/theme/app_colors.dart`.
- ❌ No external `.css` files in `web/`.
- ✅ All `@css` getters are `static List<StyleRule> get styles`.
- ✅ Mobile-first: write base styles, then add `@media (min-width: …)`
  overrides going up.
