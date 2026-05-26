// Animation stylesheet — all motion in this site comes from this file.
//
// Two pieces:
//   1. `@keyframes` rules for any non-trivial motion (fade-up, mesh drift,
//      caret blink, glow pulse, …).
//   2. A small library of utility classes (`.reveal-up`, `.tilt`, `.glass`,
//      `.gradient-text`, …) that components opt into.
//
// The IntersectionObserver in `animation_scripts.dart` toggles `.is-visible`
// on `.reveal-*` elements when they enter the viewport — the class itself
// only declares the "from" and "to" states.
//
// Reduced motion is handled both globally (in `global_styles.dart`) and
// here (extra overrides for visual properties that the global rule can't
// neutralize — e.g. clearing translateY).

import 'package:jaspr/dom.dart';

@css
List<StyleRule> get animationStyles => [
  // ===================================================================
  // 1. @keyframes
  // ===================================================================

  // Hero name entrance — blur + opacity.
  css.keyframes('name-enter', const {
    '0%':   Styles(raw: {'opacity': '0', 'filter': 'blur(12px)'}),
    '100%': Styles(raw: {'opacity': '1', 'filter': 'blur(0)'}),
  }),

  // Typewriter caret blink.
  css.keyframes('caret-blink', const {
    '0%, 100%': Styles(raw: {'opacity': '1'}),
    '50%':      Styles(raw: {'opacity': '0'}),
  }),

  // Hero background gradient mesh drift.
  css.keyframes('mesh-drift', const {
    '0%':   Styles(raw: {'transform': 'translate3d(0, 0, 0) rotate(0deg)'}),
    '50%':  Styles(raw: {'transform': 'translate3d(-3%, 2%, 0) rotate(8deg)'}),
    '100%': Styles(raw: {'transform': 'translate3d(0, 0, 0) rotate(0deg)'}),
  }),

  // Glow pulse for CTAs and the active timeline dot.
  css.keyframes('glow-pulse', const {
    '0%, 100%': Styles(raw: {
      'box-shadow': '0 0 0 0 rgba(108, 99, 255, 0.55)',
    }),
    '50%': Styles(raw: {
      'box-shadow': '0 0 0 12px rgba(108, 99, 255, 0)',
    }),
  }),

  // Scroll-down arrow bob (used under the hero).
  css.keyframes('bob', const {
    '0%, 100%': Styles(raw: {'transform': 'translateY(0)'}),
    '50%':      Styles(raw: {'transform': 'translateY(6px)'}),
  }),

  // ===================================================================
  // 2. Reveal utility classes
  //    Initial hidden state + transition; JS adds `.is-visible` to play.
  // ===================================================================

  // Base reveal — the four variants share the same transition.
  css('.reveal-up, .reveal-left, .reveal-right, .reveal-scale').styles(raw: {
    'opacity': '0',
    'transition':
        'opacity 700ms var(--ease-out), '
        'transform 700ms var(--ease-out), '
        'filter 700ms var(--ease-out)',
    'will-change': 'opacity, transform',
  }),

  css('.reveal-up').styles(raw: {'transform': 'translateY(24px)'}),
  css('.reveal-left').styles(raw: {'transform': 'translateX(-32px)'}),
  css('.reveal-right').styles(raw: {'transform': 'translateX(32px)'}),
  css('.reveal-scale').styles(raw: {'transform': 'scale(0.95)'}),

  // Visible state — JS adds this class.
  css('.reveal-up.is-visible, '
      '.reveal-left.is-visible, '
      '.reveal-right.is-visible, '
      '.reveal-scale.is-visible').styles(raw: {
    'opacity': '1',
    'transform': 'none',
  }),

  // ===================================================================
  // 3. Stagger — children of `.stagger` use --i to delay their transition.
  //    Set `style="--i: N"` inline on each child.
  // ===================================================================
  css('.stagger > *').styles(raw: {
    'transition-delay': 'calc(var(--i, 0) * 80ms)',
  }),

  // ===================================================================
  // 4. Hero — name entrance + typewriter caret.
  // ===================================================================
  css('.name-enter').styles(raw: {
    'animation': 'name-enter 1100ms var(--ease-out) both',
  }),

  css('.typewriter').styles(raw: {
    'display': 'inline-block',
    'border-right': '2px solid var(--secondary)',
    'padding-right': '0.15em',
    'animation': 'caret-blink 1s steps(1) infinite',
    'white-space': 'nowrap',
  }),

  // ===================================================================
  // 5. Hero mesh background — a fixed, blurred radial gradient that drifts.
  // ===================================================================
  css('.hero-mesh').styles(raw: {
    'position': 'absolute',
    'inset': '-20%',
    'z-index': '0',
    'pointer-events': 'none',
    'background':
        'radial-gradient(40% 40% at 30% 30%, rgba(108, 99, 255, 0.35), transparent 60%),'
        'radial-gradient(40% 40% at 70% 60%, rgba(0, 217, 255, 0.28), transparent 60%)',
    'filter': 'blur(60px) saturate(1.2)',
    'animation': 'mesh-drift 18s ease-in-out infinite',
  }),

  // ===================================================================
  // 6. Glass card surface.
  // ===================================================================
  css('.glass').styles(raw: {
    'background': 'var(--glass-bg)',
    'border': '1px solid var(--glass-border)',
    'backdrop-filter': 'blur(10px) saturate(1.1)',
    '-webkit-backdrop-filter': 'blur(10px) saturate(1.1)',
    'border-radius': '20px',
  }),

  // ===================================================================
  // 7. Gradient text (name, section titles).
  // ===================================================================
  css('.gradient-text').styles(raw: {
    'background': 'var(--brand-gradient)',
    'background-clip': 'text',
    '-webkit-background-clip': 'text',
    'color': 'transparent',
    '-webkit-text-fill-color': 'transparent',
  }),

  // ===================================================================
  // 8. 3D tilt — JS writes --rx / --ry as inline custom properties on hover.
  //    Without JS the card sits flat; on mouseleave the script clears them.
  // ===================================================================
  css('.tilt').styles(raw: {
    'transform-style': 'preserve-3d',
    'transform':
        'perspective(800px) rotateX(var(--rx, 0deg)) rotateY(var(--ry, 0deg))',
    'transition': 'transform 200ms var(--ease-out)',
    'will-change': 'transform',
  }),

  // ===================================================================
  // 8b. Magnetic — small elements lean toward the cursor on hover.
  //     JS writes --mx / --my (in px) from mousemove; mouseleave clears.
  //     We compose with any existing transform via translate3d(), which
  //     is GPU-cheap and stacks predictably (no fight with .glow-hover).
  // ===================================================================
  css('.magnetic').styles(raw: {
    'transform': 'translate3d(var(--mx, 0px), var(--my, 0px), 0)',
    'transition': 'transform 240ms var(--ease-out)',
    'will-change': 'transform',
  }),
  // Pointer-coarse devices (phones, tablets) skip the effect entirely.
  css('@media (pointer: coarse)', [
    css('.magnetic').styles(raw: {'transform': 'none'}),
  ]),

  // ===================================================================
  // 9. Glow on hover — used by CTAs and skill badges.
  // ===================================================================
  css('.glow-hover').styles(raw: {
    'transition':
        'transform 220ms var(--ease-out), box-shadow 220ms var(--ease-out)',
  }),

  css('.glow-hover:hover').styles(raw: {
    'transform': 'translateY(-2px) scale(1.03)',
    'box-shadow': '0 12px 32px -8px rgba(108, 99, 255, 0.45)',
  }),

  // Primary CTA — extra pulse on hover.
  css('.glow-pulse:hover').styles(raw: {
    'animation': 'glow-pulse 1.6s ease-out infinite',
  }),

  // ===================================================================
  // 10. Scroll-indicator bob.
  // ===================================================================
  css('.bob').styles(raw: {
    'animation': 'bob 2.4s ease-in-out infinite',
  }),

  // ===================================================================
  // 11. Reduced-motion overrides — neutralize transforms, keep opacity.
  // ===================================================================
  css('@media (prefers-reduced-motion: reduce)', [
    css('.reveal-up, .reveal-left, .reveal-right, .reveal-scale').styles(raw: {
      'opacity': '1',
      'transform': 'none',
    }),
    css('.name-enter, .typewriter, .hero-mesh, .bob, .glow-pulse:hover')
        .styles(raw: {
      'animation': 'none',
    }),
    css('.typewriter').styles(raw: {
      'border-right': '0',
    }),
    css('.tilt').styles(raw: {
      'transform': 'none',
    }),
    css('.magnetic').styles(raw: {
      'transform': 'none',
    }),
    css('.glow-hover:hover').styles(raw: {
      'transform': 'none',
    }),
  ]),
];
