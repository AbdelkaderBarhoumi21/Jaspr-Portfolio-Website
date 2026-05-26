/// The entrypoint for the **server** environment.
///
/// The [main] method only runs on the server during pre-rendering (static
/// mode). For browser-side code see `main.client.dart`.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
// Importing these files (even just for the side effect of their `@css`
// annotations) ensures the Jaspr builder includes those rules in the
// generated stylesheet.
import 'core/animations/animation_scripts.dart';
import 'core/animations/animation_styles.dart';
import 'core/theme/global_styles.dart';
import 'data/profile_data.dart';
// Generated file — do not edit.
import 'main.server.options.dart';

// ---------------------------------------------------------------------------
// SEO constants — kept here (next to the Document) rather than in
// ProfileData so the section files stay focused on UI content.
// ---------------------------------------------------------------------------
const _siteTitle = 'Abdelkader Barhoumi — Mobile Software Engineer';
const _siteDescription =
    'Portfolio of Barhoumi Abdelkader — Mobile Software Engineer building '
    'high-performance Flutter & Android apps with clean architecture, '
    'BLE/IoT integrations, and full-stack Rust/Node backends.';
const _siteUrl = 'https://abdelkaderbarhoumi.dev/';
const _ogImage = 'images/og-card.png'; // 1200×630 recommended; drop in web/images/

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);

  // Touch the style getters so the imports are never tree-shaken.
  // (Cheap — runs once at server startup.)
  // ignore: unused_local_variable
  final _ = [globalStyles, animationStyles];

  runApp(
    Document(
      title: _siteTitle,
      lang: 'en',
      // `Document(meta: ...)` emits standard <meta name="..."> tags.
      // Open Graph and Twitter tags use `property=` / non-`name` attributes,
      // so they're rendered via explicit `meta(...)` components in `head:`.
      meta: const {
        'description': _siteDescription,
        'author': ProfileData.name,
        'keywords':
            'Flutter, Dart, Android, Kotlin, Jetpack Compose, BLoC, '
            'Riverpod, mobile engineer, portfolio, ${ProfileData.location}',
        'theme-color': '#080810',
        'color-scheme': 'dark',
        'robots': 'index, follow',
      },
      head: const [
        // -----------------------------------------------------------------
        // Favicons
        // -----------------------------------------------------------------
        link(rel: 'icon', href: 'favicon.ico', type: 'image/x-icon'),
        link(
          rel: 'apple-touch-icon',
          href: 'favicon.ico',
        ),

        // -----------------------------------------------------------------
        // Font preconnect — speeds up the @import in global_styles.dart
        // -----------------------------------------------------------------
        link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
        link(
          rel: 'preconnect',
          href: 'https://fonts.gstatic.com',
          attributes: {'crossorigin': ''},
        ),

        // -----------------------------------------------------------------
        // Canonical URL
        // -----------------------------------------------------------------
        link(rel: 'canonical', href: _siteUrl),

        // -----------------------------------------------------------------
        // Open Graph (Facebook / LinkedIn / generic link previews)
        // -----------------------------------------------------------------
        meta(attributes: {'property': 'og:type',        'content': 'website'}),
        meta(attributes: {'property': 'og:site_name',   'content': _siteTitle}),
        meta(attributes: {'property': 'og:title',       'content': _siteTitle}),
        meta(attributes: {'property': 'og:description', 'content': _siteDescription}),
        meta(attributes: {'property': 'og:url',         'content': _siteUrl}),
        meta(attributes: {'property': 'og:image',       'content': '$_siteUrl$_ogImage'}),
        meta(attributes: {'property': 'og:image:width', 'content': '1200'}),
        meta(attributes: {'property': 'og:image:height','content': '630'}),
        meta(attributes: {'property': 'og:locale',      'content': 'en_US'}),

        // -----------------------------------------------------------------
        // Twitter / X card
        // -----------------------------------------------------------------
        meta(name: 'twitter:card',        content: 'summary_large_image'),
        meta(name: 'twitter:title',       content: _siteTitle),
        meta(name: 'twitter:description', content: _siteDescription),
        meta(name: 'twitter:image',       content: '$_siteUrl$_ogImage'),

        // -----------------------------------------------------------------
        // Animation scripts — IntersectionObserver, typewriter, ScrollSpy,
        // 3D tilt, custom cursor. `defer` so it doesn't block parsing.
        // -----------------------------------------------------------------
        script(defer: true, content: animationScripts),
      ],
      body: const App(),
    ),
  );
}
