# 04 — Jaspr cheatsheet

Quick reference for the Jaspr 0.23 APIs used in this project.

## Component types

| Flutter             | Jaspr equivalent             |
| ------------------- | ---------------------------- |
| `StatelessWidget`   | `StatelessComponent`         |
| `StatefulWidget`    | `StatefulComponent` (+ `@client` to actually run in the browser) |
| `Widget build()`    | `Component build()` returning HTML helpers |
| `Container/Column/Row` | `div`, `section`, `nav` from `package:jaspr/dom.dart` |

```dart
import 'package:jaspr/dom.dart';   // div, section, h1, p, a, button, …
import 'package:jaspr/jaspr.dart'; // Component, StatelessComponent, css, …
```

## Element helpers

```dart
div(classes: 'hero', [
  h1([text('Hi, I'm')]),
  span(classes: 'name', [text('Abdelkader')]),
  a(href: '#projects', classes: 'btn primary', [text('View work')]),
])
```

- Children are a `List<Component>` (last positional arg).
- `attributes: {'data-words': '…'}` to add arbitrary HTML attributes.
- Text nodes: `text('…')` (top-level) or `.text('…')` in some contexts.

## Styles via `@css`

```dart
class Hero extends StatelessComponent {
  const Hero({super.key});

  @override
  Component build(BuildContext context) => section(id: 'home', [/* … */]);

  @css
  static List<StyleRule> get styles => [
    css('#home').styles(
      minHeight: 100.vh,
      padding: .symmetric(horizontal: 2.rem, vertical: 6.rem),
      backgroundColor: AppColors.bg,
    ),
    css('#home h1').styles(
      fontSize: 4.rem,
      color: AppColors.textPrimary,
    ),
  ];
}
```

- `@css` getter must be `static List<StyleRule> get styles`.
- Jaspr bundles all `@css` rules during build → one stylesheet shipped.
- Use `.px`, `.rem`, `.em`, `.vh`, `.percent` extensions on numbers.

## Routing (used minimally here)

```dart
Router(routes: [
  Route(path: '/', title: 'Home', builder: (ctx, state) => const HomePage()),
]);
```

This site uses anchor links (`<a href="#projects">`), not multiple routes —
but the Router is kept around if we ever want a `/blog` page later.

## `@client` for browser-side state

```dart
@client
class MobileNavToggle extends StatefulComponent { … }
```

- Marks the component for the client bundle.
- Server pre-renders it; client hydrates and takes over.
- Use sparingly — most sections don't need it.

## Document head (fonts, meta, scripts)

In `main.server.dart`:

```dart
runApp(Document(
  title: 'Abdelkader Barhoumi — Mobile Engineer',
  meta: { 'description': '…' },
  styles: [ /* one-off global rules, e.g. css.import(...) */ ],
  head: [
    link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
    link(rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap'),
    script(defer: true, content: animationScripts),
  ],
  body: App(),
));
```

## Build & dev

```bash
jaspr serve        # http://localhost:8080, hot reload
jaspr build        # → build/jaspr/  (static HTML/CSS/JS)
```
