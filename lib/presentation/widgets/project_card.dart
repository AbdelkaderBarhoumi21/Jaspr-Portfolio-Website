// Card rendered inside the Projects grid.
//
// Composition: GlassCard (tilt enabled) → title + description → tag chips
// → optional repo/demo links. Hides the link affordance when `repoUrl` and
// `demoUrl` are both null on the Project model.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/project.dart';
import 'glass_card.dart';
import 'skill_badge.dart';

class ProjectCard extends StatelessComponent {
  const ProjectCard({required this.project, super.key});

  final Project project;

  @override
  Component build(BuildContext context) {
    final hasLinks = project.repoUrl != null || project.demoUrl != null;

    return GlassCard(
      tilt: true,
      extraClasses: 'project-card',
      children: [
        h3(classes: 'project-card__title', [Component.text(project.title)]),
        p(classes: 'project-card__desc', [Component.text(project.description)]),
        div(classes: 'project-card__tags', [
          for (final tag in project.tags) SkillBadge(label: tag),
        ]),
        if (hasLinks)
          div(classes: 'project-card__links', [
            if (project.repoUrl != null)
              a(
                href: project.repoUrl!,
                target: Target.blank,
                attributes: const {'rel': 'noopener noreferrer'},
                classes: 'project-card__link glow-hover',
                [Component.text('Source ↗')],
              ),
            if (project.demoUrl != null)
              a(
                href: project.demoUrl!,
                target: Target.blank,
                attributes: const {'rel': 'noopener noreferrer'},
                classes: 'project-card__link glow-hover',
                [Component.text('Live ↗')],
              ),
          ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.project-card').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.md.rem),
      height: 100.percent,
    ),
    css('.project-card__title').styles(
      color: AppColors.textPrimary,
      fontSize: 1.35.rem,
      fontWeight: AppTypography.semibold,
    ),
    css('.project-card__desc').styles(
      color: AppColors.textSecondary,
      fontSize: AppTypography.bodySize,
      lineHeight: const Unit.expression('${AppTypography.lineHeightBody}'),
      raw: {'flex': '1 1 auto'},
    ),
    css('.project-card__tags').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: const Gap(row: Unit.rem(0.5), column: Unit.rem(0.5)),
    ),
    css('.project-card__links').styles(
      display: Display.flex,
      gap: Gap(column: AppSpacing.md.rem),
      margin: Margin.only(top: AppSpacing.sm.rem),
    ),
    css('.project-card__link').styles(
      color: AppColors.secondary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.smallSize,
      padding: Padding.symmetric(
        horizontal: 0.75.rem,
        vertical: 0.4.rem,
      ),
      raw: {
        'border': '1px solid var(--glass-border)',
        'border-radius': '${AppSpacing.radiusSm}px',
        'background': 'var(--glass-bg)',
      },
    ),
  ];
}
