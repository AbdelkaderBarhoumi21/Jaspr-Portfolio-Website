# 05 — Content data

All factual content (profile, experience, projects, skills) lives in
`lib/data/`. This doc lists what each file contains so Claude knows where
to add/edit copy.

## `lib/data/profile_data.dart`

```dart
class ProfileData {
  static const name = 'Barhoumi Abdelkader';
  static const role = 'Mobile Software Engineer';
  static const subRole = 'Flutter & Android Developer';
  static const location = 'Tunis, Tunisia';
  static const tagline = 'Building high-performance cross-platform apps with clean architecture';

  static const email = 'abdelkaderbarhoumi21@gmail.com';
  static const phone = '+216 20 778 960';
  static const linkedin = 'https://www.linkedin.com/in/barhoumi23176';
  static const github = 'https://github.com/AbdelkaderBarhoumi21';

  // Typewriter words on the hero
  static const heroRoles = [
    'Flutter Developer',
    'Android Engineer',
    'Mobile Architect',
    'IoT Specialist',
  ];

  static const languages = [
    'Arabic (Native)',
    'English (B2)',
    'French (B2)',
  ];
}
```

## `lib/data/experience_data.dart`

Four entries (most recent first):

1. **Oxton Digital** — Tunis, Tunisia — *Apr 2026 – Present*
   - Sparta Coaching (Flutter, BLoC, GetStream.IO, Firebase Crashlytics)
   - Bowling Android app migration: Java + XML → Kotlin + Jetpack Compose
2. **Sifartek** — Algiers (Remote) — *Feb 2026 – Present*
   - Flutter IoT app: BLE + Wi-Fi sensor connectivity, Drift offline, Firebase sync
3. **Stoneslane** — Dubai (Remote) — *Oct 2025 – Present*
   - B2B Flutter e-commerce: ObjectBox, Algolia, Fastlane CI/CD, Google Play + App Store
4. **Nexits** — Paris (Remote) — *Oct 2025 – Dec 2025*
   - Flutter healthcare app: Riverpod, OpenAPI/Swagger + openapi-generator, Drift, CI/CD

## `lib/data/projects_data.dart`

Three personal projects:

1. **Multi-role E-commerce App** (Admin / Delivery / Customer)
   - Flutter + Laravel + PostgreSQL + Qt/QML desktop dashboard
   - Tags: Flutter, Laravel, JWT, Google Maps, Docker
2. **Real-time Chat App**
   - Flutter + Rust (Axum) backend + WebSockets + MongoDB
   - Tags: Flutter, Rust, WebSockets, MongoDB, Riverpod
3. **Smart Irrigation Control & AI Plant Shop**
   - Flutter + Gemini AI chatbot + Firebase + Weather API
   - Tags: Flutter, Gemini AI, Firebase, GetX, Docker

## `lib/data/skills_data.dart`

Grouped:

- **Mobile:** Flutter, Dart, BLoC/Cubit, Riverpod, Clean Architecture,
  Jetpack Compose, Kotlin, Android SDK
- **Backend:** Rust (Axum), Node.js, Laravel, WebSockets, REST APIs
- **Database:** Firebase, PostgreSQL, MongoDB, Drift, ObjectBox
- **DevOps:** Docker, Fastlane, CI/CD, Git, Firebase Crashlytics

## Editing rules

- Never put strings from the CV directly into a section component.
- Section components import `ProfileData`, `experiences`, `projects`,
  `skillGroups` and iterate.
- If a new field is added (e.g. "years experience"), add it to the
  matching data class first, then surface it.
