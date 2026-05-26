// Grouped skill list rendered as monospace badges in the Skills section.
//
// Order inside each group is curated, not alphabetical — the most important
// or signature tools come first so the eye lands on them.

import '../domain/models/skill_group.dart';

const List<SkillGroup> skillGroups = [
  SkillGroup(
    title: 'Mobile',
    skills: [
      'Flutter', 'Dart',
      'BLoC/Cubit', 'Riverpod', 'Provider', 'GetX',
      'Clean Architecture', 'MVC/MVVM',
      'Material Design 3', 'Responsive UI',
      'Unit/Widget/Integration Testing',
    ],
  ),
  SkillGroup(
    title: 'Android Native',
    skills: [
      'Kotlin', 'Jetpack Compose',
      'Java', 'XML Layouts', 'Android SDK',
      'Migration: XML+Java → Kotlin+Compose',
    ],
  ),
  SkillGroup(
    title: 'Backend & Real-time',
    skills: [
      'Rust (Axum)',
      'Node.js (Express)', 'WebSockets (Socket.IO)', 'Stream.IO',
      'PHP (Laravel)',
      'JWT', 'OAuth2',
    ],
  ),
  SkillGroup(
    title: 'Databases',
    skills: [
      'Firebase (Firestore)',
      'PostgreSQL', 'MySQL', 'MongoDB',
      'Drift', 'ObjectBox',
      'Supabase', 'Appwrite',
    ],
  ),
  SkillGroup(
    title: 'APIs & Services',
    skills: [
      'REST APIs', 'OpenAPI/Swagger',
      'Google Maps SDK/API',
      'Push Notifications', 'Payments',
    ],
  ),
  SkillGroup(
    title: 'DevOps & Quality',
    skills: [
      'Git/GitHub', 'CI/CD', 'Docker', 'Fastlane',
      'Firebase Crashlytics', 'Firebase Analytics',
      'Figma (UI/UX)',
    ],
  ),
];
