// Skills section.
//
// Composition:
//   - SectionTitle "Skills" with mono eyebrow "04 / skills"
//   - Responsive grid of group cards (1 col mobile → 2 cols tablet+).
//   - Each card has the group title, a mono category line, and a wrap of
//     SkillBadges. The whole card carries `.glass`, and badges keep the
//     `.glow-hover` lift from SkillBadge.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/app_anchors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/skills_data.dart';
import '../../domain/models/skill_group.dart';
import '../widgets/glass_card.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_container.dart';
import '../widgets/section_title.dart';
import '../widgets/skill_badge.dart';

class SkillsSection extends StatelessComponent {
  const SkillsSection({super.key});

  @override
  Component build(BuildContext context) {
    return SectionContainer(
      id: AppAnchors.skills,
      altBg: true,
      children: [
        const SectionTitle(
          eyebrow: '04 / skills',
          title: 'Tools I reach for',
        ),

        div(classes: 'skills__grid stagger', [
          for (final (i, group) in skillGroups.indexed)
            _SkillGroupCard(group: group, staggerIndex: i),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    // List view: one group card per row at every viewport size.
    // The other sections (About bento, Contact tiles, Projects) use
    // multi-column grids; Skills stays a single column so every chip
    // row gets the full container width and tags don't crowd each
    // other on desktop.
    css('.skills__grid').styles(
      display: Display.grid,
      gap: Gap(row: AppSpacing.md.rem),
      raw: {'grid-template-columns': 'minmax(0, 1fr)'},
    ),

    // Per-card internals.
    css('.skills-card').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.md.rem),
    ),
    css('.skills-card__head').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: 0.25.rem),
    ),
    css('.skills-card__eyebrow').styles(
      color: AppColors.secondary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.eyebrowSize,
      textTransform: TextTransform.upperCase,
      letterSpacing: AppTypography.letterSpacingEyebrow,
    ),
    css('.skills-card__title').styles(
      color: AppColors.textPrimary,
      fontSize: 1.2.rem,
      fontWeight: AppTypography.semibold,
    ),
    css('.skills-card__chips').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: const Gap(row: Unit.rem(0.5), column: Unit.rem(0.5)),
    ),
  ];
}

// Private composition — a single skill bucket rendered as a GlassCard.
// Kept local so it stays a thin formatter over SkillGroup + SkillBadge.
class _SkillGroupCard extends StatelessComponent {
  const _SkillGroupCard({required this.group, required this.staggerIndex});

  final SkillGroup group;
  final int staggerIndex;

  @override
  Component build(BuildContext context) {
    return RevealOnScroll(
      direction: RevealDirection.scale,
      staggerIndex: staggerIndex,
      children: [
        GlassCard(
          extraClasses: 'skills-card',
          children: [
            div(classes: 'skills-card__head', [
              span(classes: 'skills-card__eyebrow', [
                Component.text('// stack'),
              ]),
              h3(classes: 'skills-card__title', [
                Component.text(group.title),
              ]),
            ]),
            div(classes: 'skills-card__chips', [
              for (final skill in group.skills) SkillBadge(label: skill),
            ]),
          ],
        ),
      ],
    );
  }
}
