// Professional experience timeline data.
//
// Order: current roles first (both "Present"), then past roles in
// reverse chronological order.
//
// Bullets follow the content-writer voice: lead with verbs, ≤22 words each,
// concrete tech named explicitly. See .claude/agents/content-writer.md.

import '../domain/models/experience.dart';

const List<Experience> experiences = [
  // ---- Current ----------------------------------------------------------
  Experience(
    company: 'Oxton Digital',
    role: 'Mobile Software Engineer — Flutter & Android',
    location: 'Tunis, Tunisia · On-site',
    period: 'Apr 2026 – Present',
    bullets: [
      'Built Sparta Coaching, a cross-platform fitness app with workout tracking, exercise library, and training-plan management.',
      'Integrated GetStream.IO real-time chat and Firebase Crashlytics for production monitoring on the Flutter client.',
      'Migrated a production Android Bowling app from Java + XML to Kotlin + Jetpack Compose under Clean Architecture.',
    ],
    tech: [
      'Flutter', 'Dart', 'BLoC/Cubit',
      'Kotlin', 'Jetpack Compose', 'Java', 'XML',
      'GetStream.IO', 'Firebase Crashlytics', 'FCM',
      'Clean Architecture', 'REST APIs',
    ],
  ),
  Experience(
    company: 'Stoneslane',
    role: 'Mobile Engineer — Flutter',
    location: 'Dubai, UAE · Remote',
    period: 'Oct 2025 – Present',
    bullets: [
      'Shipped a B2B e-commerce app covering authentication, catalog, cart/checkout, order tracking, and push notifications.',
      'Integrated REST APIs and payment gateways; tuned UI performance with modular BLoC/Cubit slices.',
      'Built offline persistence on ObjectBox and a Fastlane CI/CD pipeline, publishing to Google Play and the App Store.',
    ],
    tech: [
      'Flutter', 'Dart', 'BLoC/Cubit',
      'REST APIs', 'ObjectBox',
      'Firebase (Auth, FCM, Crashlytics, Performance, Remote Config)',
      'Algolia', 'Google Maps', 'Payments',
      'CI/CD', 'Fastlane', 'Docker',
    ],
  ),

  // ---- Past -------------------------------------------------------------
  Experience(
    company: 'Sifartek',
    role: 'Mobile Software Engineer — Flutter',
    location: 'Algiers, Algeria · Remote',
    period: 'Feb 2026 – Apr 2026',
    bullets: [
      'Optimized a Flutter app for seamless IoT sensor connectivity over BLE (MDS, Nordic) and Wi-Fi protocols.',
      'Implemented Drift-backed local storage for offline-first usage with automatic cloud synchronization.',
      'Set up unit, widget, and integration tests against Firebase services to guarantee data consistency.',
    ],
    tech: [
      'Flutter', 'Dart', 'BLoC/Cubit',
      'BLE (MDS, Nordic)', 'OpenAPI', 'Drift',
      'Firebase (Storage, Cloud, FCM, Auth, Crashlytics)',
      'Cloud Sync', 'Testing',
    ],
  ),
  Experience(
    company: 'Nexits',
    role: 'Mobile Engineer — Flutter',
    location: 'Paris, France · Remote',
    period: 'Oct 2025 – Dec 2025',
    bullets: [
      'Built a healthcare app with appointments, patient profiles, notifications, and role-based access control.',
      'Generated typed API clients from OpenAPI/Swagger with openapi-generator for a safer integration surface.',
      'Established Drift offline storage and an automated CI/CD pipeline; shipped to Google Play and the App Store.',
    ],
    tech: [
      'Flutter', 'Dart', 'Riverpod',
      'REST APIs', 'OpenAPI/Swagger', 'openapi-generator',
      'Drift', 'Firebase',
      'CI/CD', 'Fastlane',
    ],
  ),
];
