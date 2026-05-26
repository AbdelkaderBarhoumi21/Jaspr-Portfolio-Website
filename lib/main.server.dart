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
// Public URL of the deployed site (used in canonical / OG / Twitter tags).
// Override at build time via `--dart-define-server=SITE_URL=https://...`.
// MUST end with a trailing slash.
const _siteUrl = String.fromEnvironment(
  'SITE_URL',
  defaultValue: 'https://abdelkaderbarhoumi21.github.io/portfolio/',
);
const _ogImage = 'images/og-card.png'; // 1200×630 recommended; drop in web/images/

// ---------------------------------------------------------------------------
// Base href.
//
// When this site is hosted at the root of a domain (e.g.
// https://example.com/), base should be '/'. When hosted under a subpath
// such as GitHub Pages project pages
// (https://user.github.io/portfolio/), base must be '/portfolio/'.
//
// The value is supplied at build time via:
//   jaspr build --dart-define-server=BASE_HREF=/portfolio/
// and falls back to '/' for local `jaspr serve`.
// ---------------------------------------------------------------------------
const _baseHref = String.fromEnvironment('BASE_HREF', defaultValue: '/');

// ---------------------------------------------------------------------------
// Favicon — inline-SVG data URL.
//
// Embedded directly in the HTML head so it never 404s, never caches stale,
// never depends on the build output copying a binary asset over. Renders
// crisp at any size (tabs, bookmarks, taskbar).
//
// Composition: violet→cyan gradient pill + white "AB" monogram (same
// glyphs we use in the navbar brand mark).
// ---------------------------------------------------------------------------
const _faviconDataUri =
    'data:image/svg+xml;utf8,'
    '<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 32 32%22>'
    '<defs>'
    '<linearGradient id=%22g%22 x1=%220%22 y1=%220%22 x2=%221%22 y2=%221%22>'
    '<stop offset=%220%22 stop-color=%22%236C63FF%22/>'
    '<stop offset=%221%22 stop-color=%22%2300D9FF%22/>'
    '</linearGradient>'
    '</defs>'
    '<rect width=%2232%22 height=%2232%22 rx=%226%22 fill=%22url(%23g)%22/>'
    '<path fill=%22white%22 d=%22M6.5 22 11 9h2.4l4.5 13h-2.4l-1.05-3.2H9.95L8.9 22zm4-5.1h3l-1.5-4.6z%22/>'
    '<path fill=%22white%22 d=%22M19.2 22V9h4.6c1.5 0 2.6.34 3.3 1.02.7.67 1.05 1.6 1.05 2.78 0 .77-.17 1.42-.5 1.95a2.7 2.7 0 0 1-1.42 1.12c.78.21 1.4.6 1.85 1.16.46.56.69 1.27.69 2.13 0 1.21-.4 2.17-1.2 2.86-.8.7-1.92 1.05-3.37 1.05zm2.4-7.7h2.05c.65 0 1.13-.15 1.45-.45.32-.3.48-.7.48-1.21 0-.52-.16-.93-.48-1.22-.32-.3-.8-.45-1.45-.45h-2.05zm0 5.7h2.36c.71 0 1.24-.16 1.6-.5.36-.32.54-.78.54-1.36 0-.59-.18-1.05-.55-1.38-.36-.33-.9-.5-1.6-.5h-2.35z%22/>'
    '</svg>';

// ---------------------------------------------------------------------------
// Pre-hydration theme script.
//
// Runs synchronously (NOT deferred) before any pixels are painted, so a
// returning light-mode user never sees the dark default flash. Order:
//   1. Read the persisted preference from `localStorage.theme`.
//   2. Fall back to the OS preference (`prefers-color-scheme: light`).
//   3. Default to dark.
// Then set `data-theme` on `<html>`, which the global :root / [data-theme]
// CSS blocks pick up before first paint.
//
// Wrapped in try/catch because some browsers throw on localStorage in
// private mode — we just no-op and let the default styles win.
// ---------------------------------------------------------------------------
const _themeBootstrapScript = '''
(function(){
  try {
    var stored = localStorage.getItem('theme');
    var mql = window.matchMedia && window.matchMedia('(prefers-color-scheme: light)');
    var theme = stored || (mql && mql.matches ? 'light' : 'dark');
    document.documentElement.setAttribute('data-theme', theme);
  } catch (_) {}
})();
''';

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
      base: _baseHref,
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
        // Favicons — inline SVG data URL.
        //
        // Embedded directly in <head>, so the browser doesn't have to
        // make a separate request for an asset that could 404, cache
        // stale, or take time to load. SVG also scales sharp at every
        // tab/bookmark/PWA size. Apple Touch Icon points at the same
        // data URL — iOS handles it correctly since Safari 13.
        // -----------------------------------------------------------------
        link(
          rel: 'icon',
          href: _faviconDataUri,
          type: 'image/svg+xml',
        ),
        link(
          rel: 'apple-touch-icon',
          href: _faviconDataUri,
        ),

        // -----------------------------------------------------------------
        // Fonts — Inter (body) + JetBrains Mono (code).
        //
        // Loaded via <link rel="stylesheet"> directly in <head> so the
        // browser discovers the font CSS during HTML parse, in parallel
        // with our own stylesheet. Significantly faster LCP than the
        // `@import url(...)` it replaces.
        //
        // The two preconnects warm up the TLS handshake to Google's CDN
        // before the stylesheet href is fetched — saves ~80–200ms on
        // first paint depending on the user's connection.
        // -----------------------------------------------------------------
        link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
        link(
          rel: 'preconnect',
          href: 'https://fonts.gstatic.com',
          attributes: {'crossorigin': ''},
        ),
        link(
          rel: 'stylesheet',
          href:
              'https://fonts.googleapis.com/css2'
              '?family=Inter:wght@400;500;600;700'
              '&family=JetBrains+Mono:wght@400;500;600'
              '&display=swap',
        ),

        // -----------------------------------------------------------------
        // Canonical URL
        // -----------------------------------------------------------------
        link(rel: 'canonical', href: _siteUrl),

        // -----------------------------------------------------------------
        // Open Graph (Facebook / LinkedIn / generic link previews)
        // -----------------------------------------------------------------
        meta(attributes: {'property': 'og:type', 'content': 'website'}),
        meta(attributes: {'property': 'og:site_name', 'content': _siteTitle}),
        meta(attributes: {'property': 'og:title', 'content': _siteTitle}),
        meta(attributes: {'property': 'og:description', 'content': _siteDescription}),
        meta(attributes: {'property': 'og:url', 'content': _siteUrl}),
        meta(attributes: {'property': 'og:image', 'content': '$_siteUrl$_ogImage'}),
        meta(attributes: {'property': 'og:image:width', 'content': '1200'}),
        meta(attributes: {'property': 'og:image:height', 'content': '630'}),
        meta(attributes: {'property': 'og:locale', 'content': 'en_US'}),

        // -----------------------------------------------------------------
        // Twitter / X card
        // -----------------------------------------------------------------
        meta(name: 'twitter:card', content: 'summary_large_image'),
        meta(name: 'twitter:title', content: _siteTitle),
        meta(name: 'twitter:description', content: _siteDescription),
        meta(name: 'twitter:image', content: '$_siteUrl$_ogImage'),

        // -----------------------------------------------------------------
        // Theme bootstrap — MUST run before paint to avoid FOUC.
        // No `defer`/`async` so the browser blocks first paint until this
        // tiny IIFE has set data-theme on <html>.
        // -----------------------------------------------------------------
        script(content: _themeBootstrapScript),

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
