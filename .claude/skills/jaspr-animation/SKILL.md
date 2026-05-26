---
name: jaspr-animation
description: Add a scroll-triggered, hover, or entrance animation to this Jaspr portfolio. Knows how to plug into the project's IntersectionObserver-based reveal system and the shared keyframe library. Use whenever the user asks to "animate", "fade in on scroll", "stagger", "tilt", "glow", or add a typewriter / cursor effect.
---

# Skill — Add an animation

## How animations work here

1. **CSS classes** for the visual effect live in
   `lib/core/animations/animation_styles.dart`.
2. **JS** (IntersectionObserver, typewriter, cursor, scrollspy, tilt) lives
   in `lib/core/animations/animation_scripts.dart` and is injected as a
   `<script>` tag in `Document(head: ...)` inside `main.server.dart`.
3. A component **opts in** by adding the right class (e.g. `reveal-up`) and,
   for staggers, an inline `--i: N` custom property.

## Recipes

### Fade + slide up on scroll
```dart
div(classes: 'reveal-up', [...])
```

### Staggered grid
```dart
div(classes: 'stagger', [
  for (var (i, p) in projects.indexed)
    div(
      classes: 'reveal-up',
      attributes: {'style': '--i: $i'},
      [ProjectCard(project: p)],
    ),
])
```

### 3D mouse tilt (project cards)
```dart
div(classes: 'tilt glass', [...])
```
The `tilt` JS listener in `animation_scripts.dart` auto-binds to every
`.tilt` element on `DOMContentLoaded`.

### Typewriter (hero title)
```dart
span(classes: 'typewriter', attributes: {
  'data-words': 'Flutter Developer|Android Engineer|Mobile Architect|IoT Specialist',
}, []),
```
The script reads `data-words` and cycles them.

### Glow on hover (CTA / skill badge)
```dart
a(classes: 'glow-hover', href: '#projects', [text('View My Work')])
```

## Hard rules

- ❌ Never write `<script>` strings inside a section/widget file.
- ❌ Never add a JS animation library.
- ✅ Every animation must honor `@media (prefers-reduced-motion: reduce)`
  — disable transforms, keep only opacity.
- ✅ Default easing: `cubic-bezier(0.22, 1, 0.36, 1)`.
- ✅ Default reveal duration: `700ms`.
