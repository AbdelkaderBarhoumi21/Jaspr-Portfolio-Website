// Projects grid.
//
// Composition:
//   - SectionTitle "Projects" with mono eyebrow "03 / projects"
//   - Short intro line above the grid
//   - Responsive grid:
//       <  bpMd  → 1 column
//       bpMd+   → 2 columns
//       bpLg+   → 3 columns
//   - Each card is a ProjectCard wrapped in a stagger-aware reveal so they
//     pop in one after the other when the grid enters the viewport.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/app_anchors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/projects_data.dart';
import '../widgets/project_card.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_container.dart';
import '../widgets/section_title.dart';

class ProjectsSection extends StatelessComponent {
  const ProjectsSection({super.key});

  @override
  Component build(BuildContext context) {
    return SectionContainer(
      id: AppAnchors.projects,
      children: [
        const SectionTitle(
          eyebrow: '03 / projects',
          title: 'Selected projects',
        ),

        RevealOnScroll(
          direction: RevealDirection.up,
          children: [
            p(classes: 'projects__intro', [
              Component.text(
                'A few things I’ve shipped on my own time — full-stack builds '
                'where the mobile client, backend, and data layer all had to '
                'work together.',
              ),
            ]),
          ],
        ),

        div(classes: 'projects__grid stagger', [
          for (final (i, p) in projects.indexed)
            RevealOnScroll(
              direction: RevealDirection.up,
              staggerIndex: i,
              extraClasses: 'projects__cell',
              children: [
                ProjectCard(project: p),
              ],
            ),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.projects__intro').styles(
      maxWidth: 640.px,
      margin: Margin.only(bottom: AppSpacing.xl.rem),
      color: AppColors.textSecondary,
      fontSize: 1.05.rem,
      lineHeight: const Unit.expression('${AppTypography.lineHeightBody}'),
    ),

    // Mobile-first single column.
    css('.projects__grid').styles(
      display: Display.grid,
      gap: const Gap(row: Unit.rem(1.5), column: Unit.rem(1.5)),
      raw: {'grid-template-columns': '1fr'},
    ),

    // Each grid cell stretches to the full row height so all cards in
    // the same row visually line up at the bottom.
    css('.projects__cell').styles(
      raw: {'height': '100%'},
    ),

    // ----- Tablet: 2 columns -----
    css.media(MediaQuery.raw('(min-width: ${AppSpacing.bpMd.toInt()}px)'), [
      css('.projects__grid').styles(raw: {
        'grid-template-columns': 'repeat(2, minmax(0, 1fr))',
      }),
    ]),

    // ----- Desktop: 3 columns -----
    css.media(MediaQuery.raw('(min-width: ${AppSpacing.bpLg.toInt()}px)'), [
      css('.projects__grid').styles(raw: {
        'grid-template-columns': 'repeat(3, minmax(0, 1fr))',
      }),
    ]),
  ];
}
