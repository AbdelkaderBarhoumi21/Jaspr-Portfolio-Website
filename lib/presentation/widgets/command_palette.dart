// ⌘K / Ctrl+K command palette.
//
// Rendered as static HTML (hidden by default). The JS in
// `animation_scripts.dart` owns all interactive behavior:
//   - Cmd/Ctrl+K (or '/') opens; Esc closes.
//   - The input filters the items by case-insensitive substring match
//     on `data-keywords`.
//   - ↑/↓ moves selection, Enter activates the highlighted item.
//   - Each item declares its action via data-attrs:
//       data-action="nav"   data-target="#home"        → smooth-scroll to anchor
//       data-action="open"  data-target="https://..."  → open URL in a new tab
//       data-action="copy"  data-target="abdel@..."    → copy to clipboard
//
// We render markup + styles here; behavior in JS keeps the palette out
// of the @client bundle. The only price is that the *content* is static
// at build time — fine for a portfolio.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/app_anchors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/profile_data.dart';

class CommandPalette extends StatelessComponent {
  const CommandPalette({super.key});

  // Convenience type alias inside the file.
  // Each entry becomes one row in the palette.
  static const List<_CmdItem> _items = [
    // ----- Navigation -----
    _CmdItem(
      group: 'Jump to',
      label: 'Home',
      hint: 'Hero',
      action: 'nav',
      target: '#${AppAnchors.home}',
      keywords: 'home hero top intro',
      iconPath: 'M3 12l9-9 9 9M5 10v10h14V10',
    ),
    _CmdItem(
      group: 'Jump to',
      label: 'About',
      hint: 'Bio and stats',
      action: 'nav',
      target: '#${AppAnchors.about}',
      keywords: 'about bio who me intro',
      iconPath: 'M12 12a4 4 0 100-8 4 4 0 000 8zM4 20a8 8 0 0116 0',
    ),
    _CmdItem(
      group: 'Jump to',
      label: 'Experience',
      hint: 'Work timeline',
      action: 'nav',
      target: '#${AppAnchors.experience}',
      keywords: 'experience work jobs timeline career',
      iconPath: 'M3 7h18M3 12h18M3 17h12',
    ),
    _CmdItem(
      group: 'Jump to',
      label: 'Projects',
      hint: 'Personal builds',
      action: 'nav',
      target: '#${AppAnchors.projects}',
      keywords: 'projects portfolio work apps',
      iconPath: 'M4 7h16v13H4zM9 7V4h6v3',
    ),
    _CmdItem(
      group: 'Jump to',
      label: 'Skills',
      hint: 'Tech stack',
      action: 'nav',
      target: '#${AppAnchors.skills}',
      keywords: 'skills tech stack tools',
      iconPath: 'M12 2l2.5 6.5L21 9l-5 4.5L17.5 21 12 17.5 6.5 21 8 13.5 3 9l6.5-.5L12 2z',
    ),
    _CmdItem(
      group: 'Jump to',
      label: 'Contact',
      hint: 'Get in touch',
      action: 'nav',
      target: '#${AppAnchors.contact}',
      keywords: 'contact hire reach email message',
      iconPath: 'M4 5h16v14H4zM4 7l8 6 8-6',
    ),

    // ----- Social / external -----
    _CmdItem(
      group: 'Open',
      label: 'GitHub',
      hint: '@AbdelkaderBarhoumi21',
      action: 'open',
      target: ProfileData.github,
      keywords: 'github code repos source profile',
      iconPath: 'M12 .5C5.65.5.5 5.65.5 12c0 5.08 3.29 9.39 7.86 10.91.58.1.79-.25.79-.56 0-.28-.01-1.02-.02-2-3.2.7-3.88-1.54-3.88-1.54-.52-1.33-1.27-1.68-1.27-1.68-1.04-.71.08-.7.08-.7 1.15.08 1.76 1.18 1.76 1.18 1.02 1.75 2.69 1.24 3.35.95.1-.74.4-1.24.73-1.52-2.55-.29-5.24-1.28-5.24-5.69 0-1.26.45-2.29 1.18-3.1-.12-.29-.51-1.47.11-3.06 0 0 .96-.31 3.16 1.18a10.95 10.95 0 0 1 5.75 0c2.2-1.49 3.16-1.18 3.16-1.18.62 1.59.23 2.77.11 3.06.73.81 1.18 1.84 1.18 3.1 0 4.42-2.69 5.39-5.26 5.68.41.35.78 1.04.78 2.1 0 1.51-.01 2.73-.01 3.1 0 .31.21.67.79.56 4.57-1.52 7.86-5.83 7.86-10.91C23.5 5.65 18.35.5 12 .5z',
      iconFilled: true,
    ),
    _CmdItem(
      group: 'Open',
      label: 'LinkedIn',
      hint: 'in/barhoumi23176',
      action: 'open',
      target: ProfileData.linkedin,
      keywords: 'linkedin profile network',
      iconPath: 'M20.45 20.45h-3.55v-5.57c0-1.33-.02-3.04-1.85-3.04-1.85 0-2.13 1.45-2.13 2.94v5.67H9.37V9h3.41v1.56h.05c.48-.9 1.64-1.85 3.37-1.85 3.6 0 4.27 2.37 4.27 5.46v6.28zM5.34 7.43a2.06 2.06 0 1 1 0-4.12 2.06 2.06 0 0 1 0 4.12zM7.12 20.45H3.56V9h3.56v11.45zM22.23 0H1.77C.79 0 0 .77 0 1.72v20.56C0 23.23.79 24 1.77 24h20.46c.98 0 1.77-.77 1.77-1.72V1.72C24 .77 23.21 0 22.23 0z',
      iconFilled: true,
    ),
    _CmdItem(
      group: 'Open',
      label: 'Download CV',
      hint: 'PDF',
      action: 'open',
      target: ProfileData.cvPath,
      keywords: 'cv resume pdf download',
      iconPath: 'M12 3v12m0 0l-4-4m4 4l4-4M4 21h16',
    ),

    // ----- Actions (copy to clipboard) -----
    _CmdItem(
      group: 'Copy',
      label: 'Email',
      hint: ProfileData.email,
      action: 'copy',
      target: ProfileData.email,
      keywords: 'copy email mail address gmail',
      iconPath: 'M8 4h8a2 2 0 012 2v12a2 2 0 01-2 2H8a2 2 0 01-2-2V6a2 2 0 012-2zM4 8h4M4 12h4M4 16h4',
    ),
    _CmdItem(
      group: 'Copy',
      label: 'Phone',
      hint: ProfileData.phone,
      action: 'copy',
      target: ProfileData.phone,
      keywords: 'copy phone tel number',
      iconPath: 'M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72c.13.96.37 1.9.72 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.91.35 1.85.59 2.81.72A2 2 0 0122 16.92z',
    ),
  ];

  @override
  Component build(BuildContext context) {
    // Group items in render order while keeping their declared order
    // inside each group.
    final groups = <String, List<_CmdItem>>{};
    for (final item in _items) {
      (groups[item.group] ??= []).add(item);
    }

    return div(
      attributes: const {
        'data-cmdk-root': '',
        'role': 'dialog',
        'aria-modal': 'true',
        'aria-hidden': 'true',
        'aria-label': 'Command palette',
      },
      classes: 'cmdk',
      [
        // Backdrop — clicking it closes the palette (JS handles this).
        div(
          attributes: const {'data-cmdk-backdrop': ''},
          classes: 'cmdk__backdrop',
          [],
        ),

        // Centered panel.
        div(classes: 'cmdk__panel glass', [
          // Input row.
          div(classes: 'cmdk__input-row', [
            span(classes: 'cmdk__input-icon', [
              _iconSvg(
                'M11 19a8 8 0 100-16 8 8 0 000 16zM21 21l-4.35-4.35',
                stroke: true,
              ),
            ]),
            // Plain <input>. JS hooks into [data-cmdk-input].
            Component.element(
              tag: 'input',
              attributes: const {
                'data-cmdk-input': '',
                'type': 'text',
                'placeholder': 'Type to search… (try "github", "email", "projects")',
                'autocomplete': 'off',
                'spellcheck': 'false',
                'aria-label': 'Search the command palette',
              },
              children: [],
            ),
            span(classes: 'cmdk__kbd', [Component.text('Esc')]),
          ]),

          // Results list.
          div(
            attributes: const {'data-cmdk-list': '', 'role': 'listbox'},
            classes: 'cmdk__list',
            [
              for (final entry in groups.entries) ...[
                div(classes: 'cmdk__group-label mono', [
                  Component.text(entry.key),
                ]),
                for (final item in entry.value) _renderItem(item),
              ],
              // Empty state — JS shows/hides this based on filter results.
              div(
                attributes: const {'data-cmdk-empty': ''},
                classes: 'cmdk__empty',
                [Component.text('No matches.')],
              ),
            ],
          ),

          // Footer with keyboard legend.
          div(classes: 'cmdk__footer mono', [
            _kbdLegend('↑↓', 'navigate'),
            _kbdLegend('↵', 'select'),
            _kbdLegend('Esc', 'close'),
          ]),
        ]),
      ],
    );
  }

  // ---- helpers --------------------------------------------------------

  static Component _renderItem(_CmdItem it) {
    return div(
      attributes: {
        'data-cmdk-item': '',
        'data-action': it.action,
        'data-target': it.target,
        // Combine label + hint + keywords into one searchable haystack.
        'data-keywords':
            '${it.label} ${it.hint} ${it.keywords}'.toLowerCase(),
        'role': 'option',
        'tabindex': '-1',
      },
      classes: 'cmdk__item',
      [
        span(classes: 'cmdk__item-icon', [
          _iconSvg(it.iconPath, stroke: !it.iconFilled),
        ]),
        div(classes: 'cmdk__item-text', [
          span(classes: 'cmdk__item-label', [Component.text(it.label)]),
          span(classes: 'cmdk__item-hint', [Component.text(it.hint)]),
        ]),
        // Right-edge action hint (↗ for open, ⏎ for nav, ⎘ for copy).
        span(classes: 'cmdk__item-kbd mono', [
          Component.text(_actionGlyph(it.action)),
        ]),
      ],
    );
  }

  static String _actionGlyph(String action) {
    switch (action) {
      case 'open':
        return '↗';
      case 'copy':
        return '⎘';
      case 'nav':
      default:
        return '↵';
    }
  }

  static Component _kbdLegend(String key, String desc) {
    return span(classes: 'cmdk__legend', [
      span(classes: 'cmdk__kbd', [Component.text(key)]),
      Component.text(' $desc'),
    ]);
  }

  /// Minimal inline-SVG factory using Jaspr's typed `svg()` / `path()`.
  /// `stroke: true` → outline icon (Lucide-style).
  /// `stroke: false` → filled icon (Simple Icons-style brand marks).
  static Component _iconSvg(String d, {bool stroke = true}) {
    return svg(
      viewBox: '0 0 24 24',
      attributes: {
        'fill': stroke ? 'none' : 'currentColor',
        if (stroke) 'stroke': 'currentColor',
        if (stroke) 'stroke-width': '2',
        if (stroke) 'stroke-linecap': 'round',
        if (stroke) 'stroke-linejoin': 'round',
        'aria-hidden': 'true',
      },
      [path(d: d, const [])],
    );
  }

  // ===========================================================
  // STYLES
  // ===========================================================
  @css
  static List<StyleRule> get styles => [
    // ----- Root: hidden by default; JS adds `.is-open` -----
    css('.cmdk').styles(
      display: Display.none,
      position: Position.fixed(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
      zIndex: const ZIndex(200),
      raw: {
        'inset': '0',
      },
    ),
    css('.cmdk.is-open').styles(display: Display.block),

    // ----- Backdrop -----
    css('.cmdk__backdrop').styles(
      position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
      raw: {
        'background': 'var(--bg-translucent-strong)',
        'backdrop-filter': 'blur(4px)',
        '-webkit-backdrop-filter': 'blur(4px)',
        'animation': 'cmdk-fade 180ms var(--ease-out) both',
      },
    ),

    // ----- Panel -----
    css('.cmdk__panel').styles(
      display: Display.flex,
      position: Position.absolute(top: 14.percent, left: Unit.zero, right: Unit.zero),
      width: 92.percent,
      maxWidth: 640.px,
      margin: Margin.symmetric(horizontal: Unit.auto),
      flexDirection: FlexDirection.column,
      raw: {
        'border-radius': '${AppSpacing.radiusLg}px',
        'overflow': 'hidden',
        'background': 'var(--surface)',
        'border': '1px solid var(--glass-border)',
        'box-shadow':
            '0 24px 64px -16px rgba(0, 0, 0, 0.6), '
            '0 0 0 1px rgba(108, 99, 255, 0.18)',
        'animation': 'cmdk-pop 220ms var(--ease-out) both',
      },
    ),

    // ----- Input row -----
    css('.cmdk__input-row').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: AppSpacing.lg.rem, vertical: AppSpacing.md.rem),
      alignItems: AlignItems.center,
      gap: Gap(column: AppSpacing.sm.rem),
      raw: {'border-bottom': '1px solid var(--divider)'},
    ),
    css('.cmdk__input-icon').styles(
      display: Display.inlineFlex,
      width: 18.px,
      height: 18.px,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppColors.textMuted,
    ),
    css('.cmdk__input-icon svg').styles(
      display: Display.block,
      width: 100.percent,
      height: 100.percent,
    ),
    css('[data-cmdk-input]').styles(
      width: 100.percent,
      color: AppColors.textPrimary,
      fontFamily: const FontFamily.list([
        AppTypography.fontBody,
        FontFamilies.sansSerif,
      ]),
      fontSize: 1.0.rem,
      raw: {
        'background': 'transparent',
        'border': '0',
        'outline': 'none',
        'flex': '1 1 auto',
      },
    ),
    css('[data-cmdk-input]::placeholder').styles(color: AppColors.textMuted),

    // ----- Kbd chip -----
    css('.cmdk__kbd').styles(
      display: Display.inlineFlex,
      padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.15.rem),
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
      },
    ),

    // ----- List -----
    css('.cmdk__list').styles(
      padding: Padding.symmetric(vertical: 0.5.rem),
      raw: {
        'max-height': 'min(60vh, 480px)',
        'overflow-y': 'auto',
      },
    ),
    css('.cmdk__group-label').styles(
      padding: Padding.only(left: AppSpacing.lg.rem, top: AppSpacing.sm.rem, bottom: 0.25.rem),
      color: AppColors.textMuted,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.eyebrowSize,
      textTransform: TextTransform.upperCase,
      letterSpacing: AppTypography.letterSpacingEyebrow,
    ),

    // ----- Item -----
    css('.cmdk__item').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: AppSpacing.lg.rem, vertical: 0.6.rem),
      cursor: Cursor.pointer,
      alignItems: AlignItems.center,
      gap: Gap(column: AppSpacing.md.rem),
      color: AppColors.textPrimary,
      raw: {
        'transition':
            'background 140ms var(--ease-out), color 140ms var(--ease-out)',
      },
    ),
    css('.cmdk__item.is-active, .cmdk__item:hover').styles(raw: {
      'background': 'rgba(108, 99, 255, 0.14)',
    }),
    css('.cmdk__item.is-hidden').styles(display: Display.none),

    css('.cmdk__item-icon').styles(
      display: Display.inlineFlex,
      width: 28.px,
      height: 28.px,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppColors.secondary,
      raw: {
        'background': 'rgba(0, 217, 255, 0.10)',
        'border': '1px solid rgba(0, 217, 255, 0.18)',
        'border-radius': '8px',
        'flex': '0 0 28px',
      },
    ),
    css('.cmdk__item-icon svg').styles(
      display: Display.block,
      width: 14.px,
      height: 14.px,
    ),
    css('.cmdk__item-text').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      raw: {'flex': '1 1 auto', 'min-width': '0'},
    ),
    css('.cmdk__item-label').styles(
      color: AppColors.textPrimary,
      fontSize: 0.95.rem,
      fontWeight: AppTypography.medium,
    ),
    css('.cmdk__item-hint').styles(
      color: AppColors.textMuted,
      fontSize: AppTypography.eyebrowSize,
      raw: {
        'white-space': 'nowrap',
        'overflow': 'hidden',
        'text-overflow': 'ellipsis',
      },
    ),
    css('.cmdk__item-kbd').styles(
      color: AppColors.textMuted,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: 1.0.rem,
    ),

    // ----- Empty state -----
    css('.cmdk__empty').styles(
      display: Display.none,
      padding: Padding.all(AppSpacing.lg.rem),
      color: AppColors.textMuted,
      textAlign: TextAlign.center,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.smallSize,
    ),
    css('.cmdk__empty.is-visible').styles(display: Display.block),

    // ----- Footer -----
    css('.cmdk__footer').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: AppSpacing.lg.rem, vertical: 0.6.rem),
      flexWrap: FlexWrap.wrap,
      gap: const Gap(row: Unit.rem(0.4), column: Unit.rem(1.0)),
      color: AppColors.textMuted,
      fontSize: AppTypography.eyebrowSize,
      raw: {'border-top': '1px solid var(--divider)'},
    ),
    css('.cmdk__legend').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      gap: Gap(column: 0.35.rem),
    ),

    // ----- Animations -----
    css.keyframes('cmdk-fade', const {
      '0%':   Styles(raw: {'opacity': '0'}),
      '100%': Styles(raw: {'opacity': '1'}),
    }),
    css.keyframes('cmdk-pop', const {
      '0%':   Styles(raw: {'opacity': '0', 'transform': 'translateY(-8px) scale(0.98)'}),
      '100%': Styles(raw: {'opacity': '1', 'transform': 'translateY(0) scale(1)'}),
    }),

    // Reduced motion: keep visibility transitions, drop the pop animation.
    css('@media (prefers-reduced-motion: reduce)', [
      css('.cmdk__backdrop').styles(raw: {'animation': 'none'}),
      css('.cmdk__panel').styles(raw: {'animation': 'none'}),
    ]),
  ];
}

// One palette row, declared declaratively above. Internal-only.
class _CmdItem {
  const _CmdItem({
    required this.group,
    required this.label,
    required this.hint,
    required this.action,
    required this.target,
    required this.keywords,
    required this.iconPath,
    this.iconFilled = false,
  });

  /// Header label this item appears under (e.g. "Jump to", "Open", "Copy").
  final String group;
  final String label;
  final String hint;
  /// 'nav' | 'open' | 'copy'.
  final String action;
  /// Anchor href / external URL / clipboard text.
  final String target;
  /// Space-separated search synonyms.
  final String keywords;
  /// Single `d` attr for the inline-SVG path.
  final String iconPath;
  /// True for brand-mark icons (filled, no stroke).
  final bool iconFilled;
}
