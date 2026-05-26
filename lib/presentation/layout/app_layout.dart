// The single page shell.
//
//   <ScrollProgress />          ← thin gradient bar at the very top
//   <Navbar />
//   <main>
//     ...sections (passed in by app.dart)...
//   </main>
//   <Footer />
//   <BackToTop />               ← floating FAB shown past the hero
//   <CursorDot/>  <CursorRing/> ← hooked by animation_scripts.dart
//
// Keeping these elements here means every page (even if we add routed
// sub-pages later) inherits them once.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';
import '../widgets/back_to_top.dart';
import '../widgets/scroll_progress.dart';
import 'footer.dart';
import 'navbar.dart';

class AppLayout extends StatelessComponent {
  const AppLayout({required this.sections, super.key});

  /// The top-level scroll sections in display order. `app.dart` builds and
  /// passes them in so this widget stays decoupled from concrete sections.
  final List<Component> sections;

  @override
  Component build(BuildContext context) {
    return div(classes: 'app', [
      // Top-of-page scroll progress bar (z-index above navbar).
      const ScrollProgress(),
      const Navbar(),
      main_(sections, classes: 'app__main'),
      const Footer(),
      // Floating back-to-top FAB — JS toggles .is-visible past ~600px.
      const BackToTop(),
      // Custom cursor — visible only on fine pointers; animation_scripts.dart
      // attaches mousemove/raf to update transforms.
      div(
        attributes: const {'data-cursor-dot': ''},
        classes: 'cursor cursor--dot',
        [],
      ),
      div(
        attributes: const {'data-cursor-ring': ''},
        classes: 'cursor cursor--ring',
        [],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    // The whole app sits in a vertical flex so the footer hugs the bottom
    // even when there's not much content yet.
    css('.app').styles(
      display: Display.flex,
      minHeight: 100.vh,
      flexDirection: FlexDirection.column,
    ),
    css('.app__main').styles(
      raw: {'flex': '1 1 auto'},
      // Top padding so anchor scrolls (and the first hero) clear the
      // fixed-position navbar. scroll-padding-top in global_styles.dart
      // handles the anchor offset, this just gives breathing room.
      padding: Padding.only(top: AppSpacing.navbarHeight.px),
    ),

    // ----- Custom cursor -----
    // Dot — small filled circle that snaps to the pointer.
    // Ring — outline circle that lags via a JS rAF easing loop.
    // Both are hidden on touch/reduced-motion by animation_scripts.dart.
    css('.cursor').styles(
      position: Position.fixed(top: Unit.zero, left: Unit.zero),
      zIndex: const ZIndex(9999),
      pointerEvents: PointerEvents.none,
      raw: {
        'border-radius': '50%',
        'will-change': 'transform',
      },
    ),
    css('.cursor--dot').styles(
      width: 8.px,
      height: 8.px,
      raw: {'background': 'var(--secondary)'},
    ),
    css('.cursor--ring').styles(
      width: 36.px,
      height: 36.px,
      raw: {
        'border': '1.5px solid var(--primary)',
        'background': 'transparent',
        'transition': 'width 200ms var(--ease-out), '
            'height 200ms var(--ease-out), '
            'border-color 200ms var(--ease-out)',
      },
    ),
    // .is-grow added by JS when hovering interactive elements.
    css('.cursor--ring.is-grow').styles(
      width: 56.px,
      height: 56.px,
      raw: {
        'border-color': 'var(--secondary)',
      },
    ),

    // On touch / coarse pointers, hide both — finger/OS cursor is enough.
    css('@media (pointer: coarse)', [
      css('.cursor').styles(display: Display.none),
    ]),
  ];
}
