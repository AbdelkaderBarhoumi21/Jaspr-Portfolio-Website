// About section.
//
// Composition:
//   - SectionTitle ("About") with mono eyebrow "01 / about"
//   - Two-column grid on desktop:
//       Left:  short bio + approach paragraph
//       Right: 3 stat cards (Years / Apps / Languages) + spoken languages chip row
//   - On mobile the grid collapses to one column.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/app_anchors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/profile_data.dart';
import '../widgets/glass_card.dart';
import '../widgets/reveal_on_scroll.dart';
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

        div(classes: 'about__grid', [
          // ----- Left column: bio + approach -----
          div(classes: 'about__copy', [
            RevealOnScroll(
              direction: RevealDirection.up,
              children: [
                p(classes: 'about__bio', [
                  Component.text(
                    "I'm a Mechatronics engineer turned Mobile Software Engineer based in "
                    "${ProfileData.location}, with hands-on experience shipping cross-platform "
                    "Flutter apps and migrating native Android codebases to Kotlin + Jetpack Compose. "
                    "I care about clean architecture, predictable state management, and code that "
                    "stays maintainable as teams and features grow.",
                  ),
                ]),
              ],
            ),
            RevealOnScroll(
              direction: RevealDirection.up,
              staggerIndex: 1,
              children: [
                p(classes: 'about__bio', [
                  Component.text(
                    'My background in embedded systems means I’m comfortable bridging hardware and '
                    'software — BLE, IoT sensors, real-time data, and offline-first storage are all '
                    'familiar territory. On the backend I reach for Rust (Axum), Node.js, or Laravel '
                    'depending on the constraints, with REST + WebSockets and typed contracts via '
                    'OpenAPI when the surface area matters.',
                  ),
                ]),
              ],
            ),
          ]),

          // ----- Right column: stats + languages -----
          div(classes: 'about__side', [
            div(classes: 'about__stats', [
              _StatCard(
                value: ProfileData.yearsExperience,
                label: 'Years of\nexperience',
                staggerIndex: 0,
              ),
              _StatCard(
                value: ProfileData.appsShipped,
                label: 'Production\napps shipped',
                staggerIndex: 1,
              ),
              _StatCard(
                value: ProfileData.spokenLanguages,
                label: 'Spoken\nlanguages',
                staggerIndex: 2,
              ),
            ]),

            RevealOnScroll(
              direction: RevealDirection.up,
              extraClasses: 'about__langs-wrap',
              children: [
                div(classes: 'about__langs', [
                  span(classes: 'about__langs-label mono', [
                    Component.text('// languages'),
                  ]),
                  div(classes: 'about__langs-row', [
                    for (final lang in ProfileData.languages)
                      SkillBadge(label: lang),
                  ]),
                ]),
              ],
            ),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    // ----- Grid -----
    css('.about__grid').styles(
      display: Display.grid,
      gap: const Gap(row: Unit.rem(2.5), column: Unit.rem(3.0)),
      raw: {
        'grid-template-columns': '1fr',
      },
    ),
    css('@media (min-width: ${AppSpacing.bpLg.toInt()}px)', [
      css('.about__grid').styles(raw: {
        'grid-template-columns': '1.2fr 1fr',
        'align-items': 'start',
      }),
    ]),

    // ----- Copy column -----
    css('.about__copy').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.md.rem),
    ),
    css('.about__bio').styles(
      color: AppColors.textSecondary,
      fontSize: 1.05.rem,
      lineHeight: const Unit.expression('${AppTypography.lineHeightBody}'),
    ),

    // ----- Side column -----
    css('.about__side').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.lg.rem),
    ),

    // ----- Stats row -----
    css('.about__stats').styles(
      display: Display.grid,
      gap: Gap(row: AppSpacing.md.rem, column: AppSpacing.md.rem),
      raw: {
        'grid-template-columns': 'repeat(3, minmax(0, 1fr))',
      },
    ),
    // Drop stats to two columns on the tiniest screens.
    css('@media (max-width: ${(AppSpacing.bpSm - 1).toInt()}px)', [
      css('.about__stats').styles(raw: {
        'grid-template-columns': 'repeat(2, minmax(0, 1fr))',
      }),
    ]),

    // ----- Stat card internals -----
    css('.stat-card').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: 0.35.rem),
    ),
    css('.stat-card__value').styles(
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: 2.2.rem,
      fontWeight: AppTypography.bold,
      letterSpacing: const Unit.em(-0.02),
      raw: {'line-height': '1'},
    ),
    css('.stat-card__label').styles(
      color: AppColors.textSecondary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.smallSize,
      raw: {'white-space': 'pre-line'},
    ),

    // ----- Languages block -----
    css('.about__langs').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.sm.rem),
    ),
    css('.about__langs-label').styles(
      color: AppColors.textMuted,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.smallSize,
    ),
    css('.about__langs-row').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: const Gap(row: Unit.rem(0.5), column: Unit.rem(0.5)),
    ),
  ];
}

// Private helper — keeps the section file readable without polluting the
// public widgets/ namespace. It just composes GlassCard + GradientText to
// produce a labeled stat tile.
class _StatCard extends StatelessComponent {
  const _StatCard({
    required this.value,
    required this.label,
    required this.staggerIndex,
  });

  final String value;
  final String label;
  final int staggerIndex;

  @override
  Component build(BuildContext context) {
    return RevealOnScroll(
      direction: RevealDirection.scale,
      staggerIndex: staggerIndex,
      children: [
        GlassCard(
          extraClasses: 'stat-card',
          children: [
            span(classes: 'stat-card__value gradient-text', [
              Component.text(value),
            ]),
            span(classes: 'stat-card__label', [Component.text(label)]),
          ],
        ),
      ],
    );
  }
}
