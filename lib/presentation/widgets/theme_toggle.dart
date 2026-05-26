// Light/dark theme toggle — sun ↔ moon icon button.
//
// @client because it owns:
//   - a hydration step that reads the current `data-theme` attr from
//     <html> (set by the pre-hydration script in main.server.dart);
//   - on-click logic that flips the attribute and persists to
//     localStorage so the choice survives reloads.
//
// We use Jaspr's `@Import.onWeb` to access `dart:html` for `window` +
// `document`. The builder generates `theme_toggle.imports.dart` with the
// web-only symbols and a no-op server stub, so this file compiles on both
// platforms. Browser code stays guarded behind `kIsWeb`.

@Import.onWeb('dart:html', show: [#window, #document])
import 'theme_toggle.imports.dart';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';

const String _themeAttr = 'data-theme';
const String _themeLight = 'light';
const String _themeDark  = 'dark';
const String _storageKey = 'theme';

@client
class ThemeToggle extends StatefulComponent {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => ThemeToggleState();
}

class ThemeToggleState extends State<ThemeToggle> {
  // Default to dark — matches the SSR output. Will be re-synced from
  // the live DOM in `initState` on the client.
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    // The pre-hydration script in `main.server.dart` has already applied
    // the user's preferred theme to <html> before our component mounted.
    // We just read it back so our internal state matches the DOM.
    final current = document.documentElement?.getAttribute(_themeAttr);
    _isDark = current != _themeLight;
  }

  void _toggle() {
    setState(() => _isDark = !_isDark);
    if (!kIsWeb) return;
    final next = _isDark ? _themeDark : _themeLight;
    document.documentElement?.setAttribute(_themeAttr, next);
    try {
      window.localStorage[_storageKey] = next;
    } catch (_) {
      // localStorage blocked (private mode / disabled) — ignore.
    }
  }

  @override
  Component build(BuildContext context) {
    return button(
      type: ButtonType.button,
      classes: _isDark
          ? 'theme-toggle magnetic is-dark'
          : 'theme-toggle magnetic',
      attributes: {
        'data-theme-toggle': '',
        'aria-label':
            _isDark ? 'Switch to light theme' : 'Switch to dark theme',
        'title':
            _isDark ? 'Switch to light theme' : 'Switch to dark theme',
        'aria-pressed': '${!_isDark}',
      },
      onClick: _toggle,
      [
        // Both icons live in the DOM at once; CSS hides the inactive one
        // via translate + opacity, giving a smooth swap instead of a pop.
        span(classes: 'theme-toggle__sun', [_sunSvg()]),
        span(classes: 'theme-toggle__moon', [_moonSvg()]),
      ],
    );
  }

  static Component _sunSvg() => svg(
    viewBox: '0 0 24 24',
    attributes: const {
      'fill': 'none',
      'stroke': 'currentColor',
      'stroke-width': '2',
      'stroke-linecap': 'round',
      'stroke-linejoin': 'round',
      'aria-hidden': 'true',
    },
    [
      const path(d: 'M12 18a6 6 0 100-12 6 6 0 000 12z', []),
      const path(
        d: 'M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41'
            'M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41',
        [],
      ),
    ],
  );

  static Component _moonSvg() => svg(
    viewBox: '0 0 24 24',
    attributes: const {
      'fill': 'none',
      'stroke': 'currentColor',
      'stroke-width': '2',
      'stroke-linecap': 'round',
      'stroke-linejoin': 'round',
      'aria-hidden': 'true',
    },
    [const path(d: 'M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z', [])],
  );

  @css
  static List<StyleRule> get styles => [
    css('.theme-toggle').styles(
      display: Display.inlineFlex,
      position: Position.relative(),
      width: 40.px,
      height: 40.px,
      cursor: Cursor.pointer,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppColors.textSecondary,
      raw: {
        'background': 'var(--glass-bg)',
        'border': '1px solid var(--glass-border)',
        'border-radius': '${AppSpacing.radiusSm}px',
        'padding': '0',
        'overflow': 'hidden',
        'transition':
            'color 200ms var(--ease-out), '
            'background 200ms var(--ease-out), '
            'border-color 200ms var(--ease-out)',
      },
    ),
    css('.theme-toggle:hover').styles(
      color: AppColors.textPrimary,
      raw: {
        'background': 'var(--primary-soft)',
        'border-color': 'rgba(108, 99, 255, 0.35)',
      },
    ),

    // Both icons sit at the center; we slide them in/out via translate +
    // fade so the swap reads as one smooth motion instead of a pop.
    css('.theme-toggle__sun, .theme-toggle__moon').styles(
      display: Display.inlineFlex,
      position: Position.absolute(),
      width: 18.px,
      height: 18.px,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      raw: {
        'transition':
            'transform 320ms var(--ease-out), '
            'opacity 220ms var(--ease-out)',
      },
    ),
    css('.theme-toggle__sun svg, .theme-toggle__moon svg').styles(
      display: Display.block,
      width: 100.percent,
      height: 100.percent,
    ),

    // Dark mode → show moon, hide sun.
    css('.theme-toggle.is-dark .theme-toggle__moon').styles(raw: {
      'transform': 'translateY(0) rotate(0deg)',
      'opacity': '1',
    }),
    css('.theme-toggle.is-dark .theme-toggle__sun').styles(raw: {
      'transform': 'translateY(120%) rotate(-90deg)',
      'opacity': '0',
    }),

    // Light mode → show sun, hide moon.
    css('.theme-toggle:not(.is-dark) .theme-toggle__moon').styles(raw: {
      'transform': 'translateY(-120%) rotate(90deg)',
      'opacity': '0',
    }),
    css('.theme-toggle:not(.is-dark) .theme-toggle__sun').styles(raw: {
      'transform': 'translateY(0) rotate(0deg)',
      'opacity': '1',
    }),
  ];
}
