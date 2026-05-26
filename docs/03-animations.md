# 03 — Animations

All motion in this site is built on **vanilla CSS keyframes + a single
IntersectionObserver script**. No animation libraries.

## Anatomy

- **CSS:** `lib/core/animations/animation_styles.dart` — `@css` getter
  exporting all keyframes and `.reveal-*` utility classes.
- **JS:** `lib/core/animations/animation_scripts.dart` — exports a Dart
  `String` of vanilla JS that gets injected once via `Document(head: ...)`
  in `main.server.dart` as a `<script>` tag.

## The reveal pattern

Every element that should animate on scroll gets one of these classes:

| Class            | Effect                                         |
| ---------------- | ---------------------------------------------- |
| `reveal-up`      | opacity 0 → 1, translateY(24px) → 0            |
| `reveal-left`    | opacity 0 → 1, translateX(-32px) → 0           |
| `reveal-right`   | opacity 0 → 1, translateX(32px)  → 0           |
| `reveal-scale`   | opacity 0 → 1, scale(0.95) → 1                 |

Initial state: `opacity: 0; transform: ...; transition: 700ms cubic-bezier(0.22, 1, 0.36, 1)`.
When the IntersectionObserver fires, it adds `is-visible` which sets opacity
to 1 and clears the transform.

## Stagger

Add `stagger` to a container; each direct child can carry `style="--i: N"`.
Children share a base reveal class, and the CSS multiplies `--i` by ~80ms
for `transition-delay`.

```html
<div class="stagger">
  <div class="reveal-up" style="--i: 0">…</div>
  <div class="reveal-up" style="--i: 1">…</div>
  <div class="reveal-up" style="--i: 2">…</div>
</div>
```

## Hero-specific effects

- **Name entrance:** `name-enter` — opacity 0 + blur(12px) → blur(0).
- **Typewriter:** `<span class="typewriter" data-words="A|B|C">` — the JS
  cycles words, types each char, then erases.
- **Gradient mesh background:** `hero-mesh` — a fixed pseudo-element with a
  radial gradient that drifts via `@keyframes mesh-drift`.

## Navbar behaviors

| Behavior                          | How                                         |
| --------------------------------- | ------------------------------------------- |
| Transparent → solid blurred on scroll | JS toggles `.is-scrolled` on `<nav>` past 40px |
| Active section highlight (ScrollSpy)  | JS observes each `<section>` and toggles `.active` on the matching link |
| Mobile hamburger (3 lines → X)        | `@client` `MobileNavToggle` flipping a class |

## Project card 3D tilt

A single JS listener on `.tilt` elements reads `mousemove`, computes
`rotateX`/`rotateY` based on cursor offset from card center, and writes them
as inline CSS custom properties (`--rx`, `--ry`). The CSS uses
`transform: perspective(800px) rotateX(var(--rx)) rotateY(var(--ry))`.

On `mouseleave` the listener clears the props → CSS transitions back to flat.

## Custom cursor

A two-element cursor (dot + ring) follows `mousemove` with `requestAnimationFrame`.
The ring uses easing (`current += (target - current) * 0.15`) to lag.
It hides on touch devices via `@media (pointer: coarse) { display: none }`.

## Reduced motion

Every keyframe + transition is wrapped in:

```css
@media (prefers-reduced-motion: reduce) {
  .reveal-up, .reveal-left, .reveal-right, .reveal-scale {
    opacity: 1;
    transform: none;
    transition: none;
  }
  .typewriter::after { display: none; }
}
```

## Easing

Default: `cubic-bezier(0.22, 1, 0.36, 1)` — used everywhere unless a
specific effect needs a punchier curve (e.g. `cubic-bezier(0.34, 1.56, 0.64, 1)`
for button pops).
