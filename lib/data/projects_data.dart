// Personal projects rendered in the Projects section grid.
//
// `repoUrl` / `demoUrl` are intentionally null below — fill in as the public
// repos/demos become available. The widget hides the link affordance when
// these are null.

import '../domain/models/project.dart';

const List<Project> projects = [
  Project(
    title: 'Multi-role E-commerce App',
    description:
        'Three Flutter apps (Admin, Delivery, Customer) sharing a Laravel REST API '
        'with JWT auth, role management, courier tracking via Google Maps, and a '
        'Qt/QML desktop dashboard.',
    tags: [
      'Flutter', 'Laravel', 'JWT',
      'PostgreSQL', 'Google Maps',
      'Firebase', 'Qt/QML', 'Docker',
    ],
  ),
  Project(
    title: 'Real-time Chat App',
    description:
        'Group messaging with online/typing status, read receipts, media sharing, '
        'search, and blocking — backed by a Rust (Axum) WebSocket server with JWT '
        'auth and MongoDB persistence.',
    tags: [
      'Flutter', 'Riverpod',
      'Rust (Axum)', 'WebSockets',
      'JWT', 'MongoDB', 'Firebase',
    ],
  ),
  Project(
    title: 'Smart Irrigation & AI Plant Shop',
    description:
        'Smart irrigation control plus a plant shop with cart and notifications. '
        'Integrates a Gemini-powered chatbot with streaming responses and a '
        'location-based weather feed with offline caching.',
    tags: [
      'Flutter', 'GetX', 'Clean Architecture',
      'Rust (Axum)', 'Gemini API', 'Streaming',
      'Firebase (FCM, Storage, Cloud Functions)',
      'CI/CD', 'Docker',
    ],
  ),
];
