// A single row in the Experience vertical timeline.
//
// Layout: a vertical line + glowing dot on the left, a GlassCard on the
// right that holds the role/company header, location/period meta, bullets,
// and tech badges.
//
// Reveal direction (left vs right) is chosen by the parent ExperienceSection
// per-index so adjacent items animate from opposite sides.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/experience.dart';
import 'glass_card.dart';
import 'reveal_on_scroll.dart';
import 'skill_badge.dart';

class TimelineItem extends StatelessComponent {
  const TimelineItem({
    required this.experience,
    required this.fromLeft,
    super.key,
  });

  final Experience experience;
  /// Whether the card animates in from the left (true) or right (false).
  final bool fromLeft;

  @override
  Component build(BuildContext context) {
    return div(classes: 'timeline-item', [
      // Marker column — line + glowing dot.
      div(classes: 'timeline-item__rail', [
        span(classes: 'timeline-item__dot glow-pulse', []),
      ]),

      // Card column.
      div(classes: 'timeline-item__body', [
        RevealOnScroll(
          direction: fromLeft ? RevealDirection.left : RevealDirection.right,
          children: [
            GlassCard(
              extraClasses: 'timeline-card',
              children: [
                // Header: role / company on top, period on the right.
                div(classes: 'timeline-card__head', [
                  div(classes: 'timeline-card__heading', [
                    h3([Component.text(experience.role)]),
                    span(classes: 'timeline-card__company', [
                      Component.text(experience.company),
                    ]),
                  ]),
                  span(classes: 'timeline-card__period mono', [
                    Component.text(experience.period),
                  ]),
                ]),

                // Location.
                p(classes: 'timeline-card__location', [
                  Component.text(experience.location),
                ]),

                // Bullets.
                ul(classes: 'timeline-card__bullets', [
                  for (final bullet in experience.bullets)
                    li([Component.text(bullet)]),
                ]),

                // Tech tags.
                div(classes: 'timeline-card__tech', [
                  for (final t in experience.tech) SkillBadge(label: t),
                ]),
              ],
            ),
          ],
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.timeline-item').styles(
      display: Display.grid,
      gap: Gap(column: AppSpacing.lg.rem),
      raw: {'grid-template-columns': 'auto 1fr'},
    ),

    // ----- Rail (line + dot) -----
    css('.timeline-item__rail').styles(
      position: Position.relative(),
      width: 24.px,
      raw: {'flex-shrink': '0'},
    ),
    css('.timeline-item__rail::before').styles(
      content: '""',
      display: Display.block,
      position: Position.absolute(top: 14.px, bottom: Unit.zero, left: 11.px),
      width: 2.px,
      raw: {'background': 'var(--divider)'},
    ),
    css('.timeline-item__dot').styles(
      display: Display.block,
      width: 14.px,
      height: 14.px,
      margin: Margin.only(top: 8.px, left: 5.px),
      raw: {
        'border-radius': '50%',
        'background': 'var(--brand-gradient)',
        'box-shadow': '0 0 0 4px rgba(108, 99, 255, 0.18)',
      },
    ),

    // ----- Card -----
    css('.timeline-card').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.md.rem),
    ),
    css('.timeline-card__head').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.baseline,
      gap: const Gap(row: Unit.rem(0.5), column: Unit.rem(1.0)),
    ),
    css('.timeline-card__heading').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: 0.15.rem),
    ),
    css('.timeline-card h3').styles(
      color: AppColors.textPrimary,
      fontSize: 1.15.rem,
      fontWeight: AppTypography.semibold,
    ),
    css('.timeline-card__company').styles(
      color: AppColors.secondary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.smallSize,
    ),
    css('.timeline-card__period').styles(
      color: AppColors.textSecondary,
      fontSize: AppTypography.smallSize,
      whiteSpace: WhiteSpace.noWrap,
    ),
    css('.timeline-card__location').styles(
      color: AppColors.textMuted,
      fontSize: AppTypography.smallSize,
    ),
    css('.timeline-card__bullets').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.sm.rem),
      padding: Padding.only(left: 1.1.rem),
    ),
    css('.timeline-card__bullets li').styles(
      color: AppColors.textSecondary,
      fontSize: AppTypography.bodySize,
      lineHeight: const Unit.expression('${AppTypography.lineHeightBody}'),
    ),
    css('.timeline-card__tech').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: const Gap(row: Unit.rem(0.5), column: Unit.rem(0.5)),
      margin: Margin.only(top: AppSpacing.xs.rem),
    ),
  ];
}
