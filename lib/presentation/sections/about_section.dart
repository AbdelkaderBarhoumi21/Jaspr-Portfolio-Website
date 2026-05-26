// About section — bento grid.
//
// Layout idea (desktop ≥ bpLg, 3 columns × 3 rows):
//
//   ┌──────────────────┬──────────────────┐
//   │  BIO   (2×2)     │  NOW             │
//   │                  ├──────────────────┤
//   │                  │  LOCATION        │
//   ├──────┬───────────┴────┬─────────────┤
//   │ YEARS│ APPS           │ LANGUAGES   │  (3 stat tiles)
//   ├──────┴────────────────┴─────────────┤
//   │  PHILOSOPHY  (3×1)                  │
//   └─────────────────────────────────────┘
//
// On mobile the tiles stack into a single column.
//
// All tiles share `.glass` + a hover lift; each one carries `.reveal-up`
// with a staggered `--i` so they pour in when the section enters view.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/app_anchors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/profile_data.dart';
import '../widgets/section_container.dart';
import '../widgets/section_title.dart';
import '../widgets/skill_badge.dart';

class AboutSection extends StatelessComponent {
  const AboutSection({super.key});

  @override
  Component build(BuildContext context) {
    return SectionContainer(
      id: AppAnchors.about,
      children: [
        const SectionTitle(eyebrow: '01 / about', title: 'About me'),

        div(classes: 'bento', [
          _BioTile(staggerIndex: 0),
          _NowTile(staggerIndex: 1),
          _LocationTile(staggerIndex: 2),
          _StatTile(
            value: ProfileData.yearsExperience,
            label: 'years of\nexperience',
            staggerIndex: 3,
          ),
          _StatTile(
            value: ProfileData.appsShipped,
            label: 'production\napps shipped',
            staggerIndex: 4,
          ),
          _LanguagesTile(staggerIndex: 5),
          _PhilosophyTile(staggerIndex: 6),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    // ----- Grid container -----
    // Mobile-first: every tile takes a full row.
    css('.bento').styles(
      display: Display.grid,
      gap: const Gap(row: Unit.rem(1.0), column: Unit.rem(1.0)),
      raw: {'grid-template-columns': '1fr'},
    ),

    // ----- Base tile look -----
    css('.bento-tile').styles(
      display: Display.flex,
      padding: Padding.all(AppSpacing.lg.rem),
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.sm.rem),
      raw: {
        'background': 'var(--glass-bg)',
        'border': '1px solid var(--glass-border)',
        'backdrop-filter': 'blur(10px) saturate(1.1)',
        '-webkit-backdrop-filter': 'blur(10px) saturate(1.1)',
        'border-radius': '${AppSpacing.radiusLg}px',
        'transition':
            'transform 220ms var(--ease-out), '
            'box-shadow 220ms var(--ease-out), '
            'border-color 220ms var(--ease-out)',
        'min-height': '100%', // fill grid cell when row-spanning
      },
    ),
    css('.bento-tile:hover').styles(raw: {
      'transform': 'translateY(-3px)',
      'box-shadow': '0 14px 36px -16px rgba(108, 99, 255, 0.45)',
      'border-color': 'rgba(108, 99, 255, 0.35)',
    }),

    css('.bento-tile__eyebrow').styles(
      color: AppColors.secondary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.eyebrowSize,
      textTransform: TextTransform.upperCase,
      letterSpacing: AppTypography.letterSpacingEyebrow,
    ),

    // ----- Bio tile -----
    css('.bento-tile--bio p').styles(
      color: AppColors.textSecondary,
      fontSize: 1.05.rem,
      lineHeight: const Unit.expression('${AppTypography.lineHeightBody}'),
    ),
    css('.bento-tile--bio p + p').styles(
      margin: Margin.only(top: AppSpacing.md.rem),
    ),

    // ----- Now tile -----
    css('.bento-tile--now').styles(raw: {'overflow': 'hidden', 'position': 'relative'}),
    css('.bento-tile--now::before').styles(
      content: '""',
      position: Position.absolute(top: (-30).px, right: (-30).px),
      width: 120.px,
      height: 120.px,
      raw: {
        'background':
            'radial-gradient(circle, rgba(108, 99, 255, 0.40), transparent 70%)',
        'filter': 'blur(20px)',
        'pointer-events': 'none',
      },
    ),
    css('.bento-tile--now .now__title').styles(
      color: AppColors.textPrimary,
      fontSize: 1.2.rem,
      fontWeight: AppTypography.semibold,
      lineHeight: const Unit.expression('1.3'),
    ),
    css('.bento-tile--now .now__detail').styles(
      color: AppColors.textSecondary,
      fontSize: AppTypography.smallSize,
    ),
    css('.bento-tile--now .now__chip').styles(
      display: Display.inlineFlex,
      padding: Padding.symmetric(horizontal: 0.6.rem, vertical: 0.3.rem),
      alignItems: AlignItems.center,
      gap: Gap(column: 0.4.rem),
      color: AppColors.textPrimary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.eyebrowSize,
      raw: {
        'border-radius': '${AppSpacing.radiusFull}px',
        'background': 'rgba(0, 217, 255, 0.10)',
        'border': '1px solid rgba(0, 217, 255, 0.22)',
        'width': 'fit-content',
      },
    ),
    css('.bento-tile--now .now__pulse').styles(
      display: Display.inlineBlock,
      width: 8.px,
      height: 8.px,
      raw: {
        'background': 'var(--secondary)',
        'border-radius': '50%',
        'box-shadow': '0 0 0 0 rgba(0, 217, 255, 0.65)',
        'animation': 'glow-pulse 1.6s ease-out infinite',
      },
    ),

    // ----- Location tile -----
    css('.bento-tile--location .loc__city').styles(
      color: AppColors.textPrimary,
      fontSize: 1.4.rem,
      fontWeight: AppTypography.semibold,
    ),
    css('.bento-tile--location .loc__country').styles(
      color: AppColors.textSecondary,
      fontSize: AppTypography.smallSize,
    ),

    // ----- Stat tiles -----
    css('.bento-tile--stat').styles(
      justifyContent: JustifyContent.spaceBetween,
    ),
    css('.bento-tile--stat .stat__value').styles(
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: 3.0.rem,
      fontWeight: AppTypography.bold,
      letterSpacing: const Unit.em(-0.02),
      raw: {'line-height': '1'},
    ),
    css('.bento-tile--stat .stat__label').styles(
      color: AppColors.textSecondary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.smallSize,
      raw: {'white-space': 'pre-line'},
    ),

    // ----- Languages tile -----
    css('.bento-tile--langs .langs__row').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: const Gap(row: Unit.rem(0.4), column: Unit.rem(0.4)),
    ),

    // ----- Philosophy tile -----
    css('.bento-tile--philosophy').styles(raw: {
      'background':
          'linear-gradient(135deg, rgba(108, 99, 255, 0.10), rgba(0, 217, 255, 0.05))',
    }),
    css('.bento-tile--philosophy .philosophy__quote').styles(
      color: AppColors.textPrimary,
      fontSize: 1.15.rem,
      fontWeight: AppTypography.medium,
      lineHeight: const Unit.expression('${AppTypography.lineHeightBody}'),
    ),
    css('.bento-tile--philosophy .philosophy__quote::before').styles(
      content: '"“"',
      display: Display.inlineBlock,
      margin: Margin.only(right: 0.25.rem),
      color: AppColors.secondary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: 1.6.rem,
      raw: {'vertical-align': '-0.15em', 'line-height': '0.8'},
    ),

    // ----- Stagger ordering — drop a transition-delay per --i (set inline) -----
    css('.bento > *').styles(raw: {
      'transition-delay': 'calc(var(--i, 0) * 70ms)',
    }),

    // ============================================================
    // Tablet+ : 2 columns
    // ============================================================
    css('@media (min-width: ${AppSpacing.bpMd.toInt()}px)', [
      css('.bento').styles(raw: {
        'grid-template-columns': 'repeat(2, minmax(0, 1fr))',
        'grid-auto-flow': 'row dense',
      }),
      css('.bento-tile--bio').styles(raw: {
        'grid-column': 'span 2',
      }),
      css('.bento-tile--philosophy').styles(raw: {
        'grid-column': 'span 2',
      }),
    ]),

    // ============================================================
    // Desktop : 3 columns, bento layout
    // ============================================================
    css('@media (min-width: ${AppSpacing.bpLg.toInt()}px)', [
      css('.bento').styles(raw: {
        'grid-template-columns': 'repeat(3, minmax(0, 1fr))',
        'grid-auto-rows': 'minmax(140px, auto)',
      }),
      css('.bento-tile--bio').styles(raw: {
        'grid-column': 'span 2',
        'grid-row': 'span 2',
      }),
      // Now + Location each take col 3, stacked.
      css('.bento-tile--now').styles(raw: {'grid-column': '3'}),
      css('.bento-tile--location').styles(raw: {'grid-column': '3'}),

      // Stat row (years + apps + languages) — three columns wide.
      css('.bento-tile--stat, .bento-tile--langs').styles(raw: {
        'grid-column': 'span 1',
      }),

      // Philosophy spans all three columns at the bottom.
      css('.bento-tile--philosophy').styles(raw: {
        'grid-column': 'span 3',
      }),
    ]),
  ];
}

// ----------------------------------------------------------------------
// Private bento tiles. Kept inside this file because nothing else in the
// project would use them — each tile is a tightly-coupled composition of
// glass surface + one block of About content.
// ----------------------------------------------------------------------

/// Shared wrapper that adds the reveal class + stagger index inline style.
class _BentoTile extends StatelessComponent {
  const _BentoTile({
    required this.staggerIndex,
    required this.variantClass,
    required this.children,
  });

  final int staggerIndex;
  final String variantClass; // e.g. 'bento-tile--bio'
  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'bento-tile $variantClass reveal-up',
      attributes: {'style': '--i: $staggerIndex'},
      children,
    );
  }
}

// -- Bio -------------------------------------------------------------------
class _BioTile extends StatelessComponent {
  const _BioTile({required this.staggerIndex});
  final int staggerIndex;

  @override
  Component build(BuildContext context) {
    return _BentoTile(
      staggerIndex: staggerIndex,
      variantClass: 'bento-tile--bio',
      children: [
        span(classes: 'bento-tile__eyebrow', [Component.text('// who')]),
        p([
          Component.text(
            "I'm a Mechatronics engineer turned Mobile Software Engineer based "
            "in ${ProfileData.location}, shipping cross-platform Flutter apps "
            "and migrating native Android codebases to Kotlin + Jetpack Compose. "
            "I care about clean architecture, predictable state, and code that "
            "stays maintainable as teams and features grow.",
          ),
        ]),
        p([
          Component.text(
            'My embedded background means I’m comfortable bridging hardware '
            'and software — BLE, IoT sensors, real-time data, and offline-first '
            'storage are all familiar territory. On the backend I reach for '
            'Rust (Axum), Node.js, or Laravel depending on the constraints.',
          ),
        ]),
      ],
    );
  }
}

// -- Now -------------------------------------------------------------------
class _NowTile extends StatelessComponent {
  const _NowTile({required this.staggerIndex});
  final int staggerIndex;

  @override
  Component build(BuildContext context) {
    return _BentoTile(
      staggerIndex: staggerIndex,
      variantClass: 'bento-tile--now',
      children: [
        span(classes: 'bento-tile__eyebrow', [Component.text('// now')]),
        span(classes: 'now__chip', [
          span(classes: 'now__pulse', []),
          Component.text(ProfileData.nowPlace),
        ]),
        span(classes: 'now__title', [Component.text(ProfileData.nowDoing)]),
        span(classes: 'now__detail', [Component.text(ProfileData.nowDetail)]),
      ],
    );
  }
}

// -- Location --------------------------------------------------------------
class _LocationTile extends StatelessComponent {
  const _LocationTile({required this.staggerIndex});
  final int staggerIndex;

  @override
  Component build(BuildContext context) {
    // Split "Tunis, Tunisia" → ["Tunis", "Tunisia"] for the big/small layout.
    final parts = ProfileData.location.split(',');
    final city = parts.first.trim();
    final country = parts.length > 1 ? parts[1].trim() : '';
    return _BentoTile(
      staggerIndex: staggerIndex,
      variantClass: 'bento-tile--location',
      children: [
        span(classes: 'bento-tile__eyebrow', [Component.text('// based in')]),
        span(classes: 'loc__city', [Component.text(city)]),
        if (country.isNotEmpty)
          span(classes: 'loc__country', [Component.text('$country · GMT+1')]),
      ],
    );
  }
}

// -- Stat ------------------------------------------------------------------
class _StatTile extends StatelessComponent {
  const _StatTile({
    required this.value,
    required this.label,
    required this.staggerIndex,
  });

  final String value;
  final String label;
  final int staggerIndex;

  @override
  Component build(BuildContext context) {
    return _BentoTile(
      staggerIndex: staggerIndex,
      variantClass: 'bento-tile--stat',
      children: [
        span(classes: 'stat__value gradient-text', [Component.text(value)]),
        span(classes: 'stat__label', [Component.text(label)]),
      ],
    );
  }
}

// -- Languages -------------------------------------------------------------
class _LanguagesTile extends StatelessComponent {
  const _LanguagesTile({required this.staggerIndex});
  final int staggerIndex;

  @override
  Component build(BuildContext context) {
    return _BentoTile(
      staggerIndex: staggerIndex,
      variantClass: 'bento-tile--langs',
      children: [
        span(classes: 'bento-tile__eyebrow', [Component.text('// languages')]),
        div(classes: 'langs__row', [
          for (final lang in ProfileData.languages)
            SkillBadge(label: lang),
        ]),
      ],
    );
  }
}

// -- Philosophy ------------------------------------------------------------
class _PhilosophyTile extends StatelessComponent {
  const _PhilosophyTile({required this.staggerIndex});
  final int staggerIndex;

  @override
  Component build(BuildContext context) {
    return _BentoTile(
      staggerIndex: staggerIndex,
      variantClass: 'bento-tile--philosophy',
      children: [
        span(classes: 'bento-tile__eyebrow', [Component.text('// how')]),
        p(classes: 'philosophy__quote', [
          Component.text(ProfileData.philosophy),
        ]),
      ],
    );
  }
}
