// Sticky top navigation.
//
// Three pieces:
//   1. Static brand mark + desktop links + mobile hamburger button.
//   2. `data-navbar` + `data-nav-link` data-attrs that the vanilla-JS in
//      animation_scripts.dart hooks into for scroll-blur and ScrollSpy.
//   3. `MobileNavToggle` — the only @client component on the page so the
//      hamburger can flip the menu open/closed without a full Stateful
//      hydration of the whole navbar.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/app_anchors.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/theme_toggle.dart';
import '../../data/profile_data.dart';

class Navbar extends StatelessComponent {
  const Navbar({super.key});

  @override
  Component build(BuildContext context) {
    return nav(
      attributes: const {'data-navbar': ''},
      classes: 'navbar',
      [
        div(classes: 'navbar__inner', [
          // Brand mark — links back to #home.
          //
          // Inline SVG monogram instead of an <img> file so it can never
          // 404 / load slow / break — and so it scales sharp at any DPI.
          // The pill background uses the brand gradient defined in :root.
          a(
            href: AppAnchors.hash(AppAnchors.home),
            classes: 'navbar__brand',
            [
              span(
                classes: 'navbar__brand-mark',
                attributes: const {'aria-hidden': 'true'},
                [
                  svg(
                    viewBox: '0 0 32 32',
                    attributes: const {'aria-hidden': 'true'},
                    [
                      // Stylized "AB" monogram (two paths so the letters
                      // can sit on a single visual baseline).
                      const path(
                        d: 'M6.5 22 11 9h2.4l4.5 13h-2.4l-1.05-3.2H9.95L8.9 22zm4-5.1h3l-1.5-4.6z',
                        attributes: {'fill': 'white'},
                        [],
                      ),
                      const path(
                        d: 'M19.2 22V9h4.6c1.5 0 2.6.34 3.3 1.02.7.67 1.05 1.6 1.05 2.78 0 .77-.17 1.42-.5 1.95a2.7 2.7 0 0 1-1.42 1.12c.78.21 1.4.6 1.85 1.16.46.56.69 1.27.69 2.13 0 1.21-.4 2.17-1.2 2.86-.8.7-1.92 1.05-3.37 1.05zm2.4-7.7h2.05c.65 0 1.13-.15 1.45-.45.32-.3.48-.7.48-1.21 0-.52-.16-.93-.48-1.22-.32-.3-.8-.45-1.45-.45h-2.05zm0 5.7h2.36c.71 0 1.24-.16 1.6-.5.36-.32.54-.78.54-1.36 0-.59-.18-1.05-.55-1.38-.36-.33-.9-.5-1.6-.5h-2.35z',
                        attributes: {'fill': 'white'},
                        [],
                      ),
                    ],
                  ),
                ],
              ),
              span(classes: 'navbar__brand-name', [
                Component.text(ProfileData.firstName),
              ]),
            ],
          ),

          // Desktop link list.
          ul(classes: 'navbar__links', [
            for (final item in AppAnchors.items)
              li([
                a(
                  href: AppAnchors.hash(item.id),
                  classes: 'navbar__link',
                  attributes: {'data-nav-link': ''},
                  [Component.text(item.label)],
                ),
              ]),
          ]),

          // Right-side actions: ⌘K hint (desktop), theme toggle, mobile hamburger.
          div(classes: 'navbar__actions', [
            // Discoverability chip for the command palette. The JS in
            // animation_scripts.dart exposes window.__openCmdK so this
            // button can trigger the same flow as the keyboard shortcut.
            button(
              type: ButtonType.button,
              attributes: const {
                'data-open-cmdk': '',
                'aria-label': 'Open command palette',
              },
              classes: 'cmdk-hint mono',
              [
                span([Component.text('⌘')]),
                span([Component.text('K')]),
              ],
            ),
            // Light/dark theme switch (@client island).
            const ThemeToggle(),
            // Mobile-only hamburger (@client island).
            const MobileNavToggle(),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    // ----- Bar -----
    css('.navbar').styles(
      position: Position.fixed(top: Unit.zero, left: Unit.zero, right: Unit.zero),
      zIndex: const ZIndex(100),
      raw: {
        'transition':
            'background 220ms var(--ease-out), '
            'backdrop-filter 220ms var(--ease-out), '
            'border-color 220ms var(--ease-out)',
        'border-bottom': '1px solid transparent',
      },
    ),
    // .is-scrolled is added by JS once scrollY > 40
    css('.navbar.is-scrolled').styles(raw: {
      'background': 'var(--bg-translucent)',
      'backdrop-filter': 'blur(14px) saturate(1.1)',
      '-webkit-backdrop-filter': 'blur(14px) saturate(1.1)',
      'border-bottom-color': 'var(--divider)',
    }),
    css('.navbar__inner').styles(
      display: Display.flex,
      width: 100.percent,
      height: AppSpacing.navbarHeight.px,
      maxWidth: AppSpacing.containerXl.px,
      padding: Padding.symmetric(horizontal: AppSpacing.gutter.rem),
      margin: Margin.symmetric(horizontal: Unit.auto),
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
    ),

    // ----- Brand -----
    css('.navbar__brand').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      gap: Gap(column: AppSpacing.sm.rem),
      color: AppColors.textPrimary,
      fontWeight: AppTypography.semibold,
      textDecoration: const TextDecoration(line: TextDecorationLine.none),
    ),
    // Inline-SVG brand mark — gradient pill with the AB monogram.
    css('.navbar__brand-mark').styles(
      display: Display.inlineFlex,
      width: 32.px,
      height: 32.px,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      raw: {
        'background': 'var(--brand-gradient)',
        'border-radius': '${AppSpacing.radiusSm}px',
        'box-shadow': '0 4px 12px -4px rgba(108, 99, 255, 0.55)',
      },
    ),
    css('.navbar__brand-mark svg').styles(
      display: Display.block,
      width: 22.px,
      height: 22.px,
    ),
    css('.navbar__brand-name').styles(
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.smallSize,
      letterSpacing: const Unit.em(0.05),
    ),

    // ----- Right-side actions cluster -----
    css('.navbar__actions').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      gap: Gap(column: AppSpacing.sm.rem),
    ),

    // ----- ⌘K hint button (desktop only) -----
    css('.cmdk-hint').styles(
      display: Display.none, // shown via the desktop media query below
      padding: Padding.symmetric(horizontal: 0.55.rem, vertical: 0.3.rem),
      cursor: Cursor.pointer,
      alignItems: AlignItems.center,
      gap: Gap(column: 0.2.rem),
      color: AppColors.textSecondary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.eyebrowSize,
      raw: {
        'background': 'var(--glass-bg)',
        'border': '1px solid var(--glass-border)',
        'border-radius': '6px',
        'transition':
            'color 180ms var(--ease-out), '
            'background 180ms var(--ease-out), '
            'border-color 180ms var(--ease-out)',
      },
    ),
    css('.cmdk-hint:hover').styles(
      color: AppColors.textPrimary,
      raw: {
        'background': 'rgba(108, 99, 255, 0.12)',
        'border-color': 'rgba(108, 99, 255, 0.35)',
      },
    ),

    // ----- Desktop links -----
    css('.navbar__links').styles(
      display: Display.none,
      alignItems: AlignItems.center,
      gap: Gap(column: AppSpacing.lg.rem),
      raw: {'list-style': 'none'},
    ),
    css('.navbar__link').styles(
      color: AppColors.textSecondary,
      fontSize: AppTypography.smallSize,
      fontWeight: AppTypography.medium,
      textDecoration: const TextDecoration(line: TextDecorationLine.none),
      raw: {
        'transition': 'color 180ms var(--ease-out)',
        'position': 'relative',
      },
    ),
    css('.navbar__link:hover').styles(color: AppColors.textPrimary),
    // ScrollSpy adds .active to the visible-section link.
    css('.navbar__link.active').styles(color: AppColors.textPrimary),
    css('.navbar__link.active::after').styles(
      content: '""',
      display: Display.block,
      position: Position.absolute(left: Unit.zero, right: Unit.zero, bottom: (-6).px),
      height: 2.px,
      raw: {
        'background': 'var(--brand-gradient)',
        'border-radius': '2px',
      },
    ),

    // ----- Hamburger button (mobile) -----
    css('.nav-toggle').styles(
      display: Display.inlineFlex,
      width: 40.px,
      height: 40.px,
      cursor: Cursor.pointer,
      flexDirection: FlexDirection.column,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      gap: Gap(row: 5.px),
      color: AppColors.textPrimary,
      raw: {
        'background': 'transparent',
        'border': '1px solid var(--glass-border)',
        'border-radius': '${AppSpacing.radiusSm}px',
        'padding': '0',
      },
    ),
    css('.nav-toggle__bar').styles(
      display: Display.block,
      width: 18.px,
      height: 2.px,
      raw: {
        'background': 'currentColor',
        'border-radius': '2px',
        'transition':
            'transform 240ms var(--ease-out), '
            'opacity 240ms var(--ease-out)',
      },
    ),
    // Open state — collapse to an X.
    css('.nav-toggle.is-open .nav-toggle__bar:nth-child(1)').styles(raw: {
      'transform': 'translateY(7px) rotate(45deg)',
    }),
    css('.nav-toggle.is-open .nav-toggle__bar:nth-child(2)').styles(raw: {
      'opacity': '0',
    }),
    css('.nav-toggle.is-open .nav-toggle__bar:nth-child(3)').styles(raw: {
      'transform': 'translateY(-7px) rotate(-45deg)',
    }),

    // ----- Drawer -----
    css('.mobile-menu').styles(
      position: Position.fixed(
        top: AppSpacing.navbarHeight.px,
        left: AppSpacing.md.rem,
        right: AppSpacing.md.rem,
      ),
      zIndex: const ZIndex(99),
      padding: Padding.all(AppSpacing.lg.rem),
      raw: {
        'border-radius': '${AppSpacing.radiusLg}px',
        'transform': 'translateY(-8px)',
        'opacity': '0',
        'pointer-events': 'none',
        'transition':
            'opacity 220ms var(--ease-out), '
            'transform 220ms var(--ease-out)',
      },
    ),
    css('.mobile-menu.is-open').styles(raw: {
      'transform': 'translateY(0)',
      'opacity': '1',
      'pointer-events': 'auto',
    }),
    css('.mobile-menu__links').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.md.rem),
      raw: {'list-style': 'none'},
    ),
    css('.mobile-menu__link').styles(
      display: Display.block,
      padding: Padding.symmetric(vertical: 0.5.rem),
      color: AppColors.textPrimary,
      fontSize: 1.1.rem,
      fontWeight: AppTypography.medium,
      textDecoration: const TextDecoration(line: TextDecorationLine.none),
    ),
    css('.mobile-menu__link:hover').styles(color: AppColors.secondary),

    // ----- Responsive: show links on desktop, hide hamburger -----
    css.media(MediaQuery.raw('(min-width: ${AppSpacing.bpMd.toInt()}px)'), [
      css('.navbar__links').styles(display: Display.flex),
      css('.cmdk-hint').styles(display: Display.inlineFlex),
      css('.nav-toggle').styles(display: Display.none),
      css('.mobile-menu').styles(display: Display.none),
      css('.navbar__inner').styles(
        padding: Padding.symmetric(horizontal: AppSpacing.gutterDesktop.rem),
      ),
    ]),
  ];
}

// ---------------------------------------------------------------------------
// Mobile menu — the only @client (interactive) island in the whole site.
// Pre-rendered on the server (closed state), hydrated on the client so the
// button click can toggle the menu without a page reload.
// ---------------------------------------------------------------------------
@client
class MobileNavToggle extends StatefulComponent {
  const MobileNavToggle();

  @override
  State<MobileNavToggle> createState() => MobileNavToggleState();
}

class MobileNavToggleState extends State<MobileNavToggle> {
  bool _open = false;

  void _toggle() => setState(() => _open = !_open);

  @override
  Component build(BuildContext context) {
    final isOpen = _open;
    return Component.fragment([
      // Hamburger button.
      button(
        type: ButtonType.button,
        classes: isOpen ? 'nav-toggle is-open' : 'nav-toggle',
        attributes: {
          'aria-label': 'Toggle navigation',
          'aria-expanded': '$isOpen',
        },
        onClick: _toggle,
        [
          span(classes: 'nav-toggle__bar', []),
          span(classes: 'nav-toggle__bar', []),
          span(classes: 'nav-toggle__bar', []),
        ],
      ),
      // Drawer.
      div(
        classes: isOpen
            ? 'mobile-menu is-open glass'
            : 'mobile-menu glass',
        [
          ul(classes: 'mobile-menu__links', [
            for (final item in AppAnchors.items)
              li([
                // NOTE: do NOT pass `onClick` here — Jaspr's <a onClick>
                // overrides the default link behavior and the anchor jump
                // never fires. The drawer auto-closes via the global JS
                // handler in animation_scripts.dart (it listens for
                // clicks on .mobile-menu__link and removes .is-open).
                a(
                  href: AppAnchors.hash(item.id),
                  classes: 'mobile-menu__link',
                  [Component.text(item.label)],
                ),
              ]),
          ]),
        ],
      ),
    ]);
  }

}
