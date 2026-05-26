// All client-side animation behaviors as a single vanilla-JS string.
//
// Injected once into <head> as a `<script defer>` by `main.server.dart`.
// The script runs after HTML is parsed (defer) and wires up six things:
//
//   1. Reveal on scroll  — IntersectionObserver toggles `.is-visible` on
//      `.reveal-*` elements.
//   2. Typewriter        — cycles words listed in `data-words` on
//      `.typewriter` elements.
//   3. Navbar scroll     — toggles `.is-scrolled` on `[data-navbar]` past
//      40px of scroll.
//   4. ScrollSpy         — toggles `.active` on `[data-nav-link]` whose
//      `href="#section"` matches the most visible section.
//   5. 3D card tilt      — `mousemove` on `.tilt` writes `--rx` / `--ry`
//      custom properties; `mouseleave` clears them.
//   6. Custom cursor     — a dot + ring follow the mouse, the ring lags.
//      Hidden on touch devices via CSS.
//
// All behaviors check `prefers-reduced-motion` and bail out (or fall back
// to a no-animation path) when motion is reduced.
//
// Using a raw multiline string (`r''' ... '''`) keeps the JS un-escaped so
// it stays readable. Dart `$` interpolations inside this string would need
// to be escaped — the raw prefix avoids that footgun entirely.

const String animationScripts = r'''
(() => {
  'use strict';
  if (typeof window === 'undefined') return;

  const prefersReduced =
    window.matchMedia &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  const ready = (fn) =>
    document.readyState === 'loading'
      ? document.addEventListener('DOMContentLoaded', fn, { once: true })
      : fn();

  ready(() => {
    // ---------------------------------------------------------------
    // 1. Reveal on scroll
    // ---------------------------------------------------------------
    const revealEls = document.querySelectorAll(
      '.reveal-up, .reveal-left, .reveal-right, .reveal-scale'
    );

    if (prefersReduced || !('IntersectionObserver' in window)) {
      revealEls.forEach((el) => el.classList.add('is-visible'));
    } else {
      const revealIO = new IntersectionObserver(
        (entries) => {
          for (const entry of entries) {
            if (entry.isIntersecting) {
              entry.target.classList.add('is-visible');
              revealIO.unobserve(entry.target);
            }
          }
        },
        { rootMargin: '0px 0px -10% 0px', threshold: 0.12 }
      );
      revealEls.forEach((el) => revealIO.observe(el));
    }

    // ---------------------------------------------------------------
    // 2. Typewriter — cycles words from data-words="A|B|C"
    //
    // Lazy-started: each .typewriter element runs the cycle only after
    // it actually intersects the viewport. On a deep-linked load that
    // lands the user halfway down the page, we don't burn timers on
    // an off-screen hero. The observer self-unobserves once started.
    // ---------------------------------------------------------------
    const startTypewriter = (el) => {
      const raw = el.getAttribute('data-words') || '';
      const words = raw.split('|').map((w) => w.trim()).filter(Boolean);
      if (words.length === 0) return;

      if (prefersReduced) {
        el.textContent = words[0];
        return;
      }

      const typeSpeed = 70;
      const eraseSpeed = 40;
      const wordPause = 1400;
      const betweenPause = 350;

      let wordIdx = 0;
      let charIdx = 0;
      let mode = 'type'; // 'type' | 'hold' | 'erase'

      const tick = () => {
        const word = words[wordIdx];
        if (mode === 'type') {
          charIdx += 1;
          el.textContent = word.slice(0, charIdx);
          if (charIdx === word.length) {
            mode = 'hold';
            setTimeout(tick, wordPause);
            return;
          }
          setTimeout(tick, typeSpeed);
        } else if (mode === 'hold') {
          mode = 'erase';
          setTimeout(tick, eraseSpeed);
        } else {
          charIdx -= 1;
          el.textContent = word.slice(0, Math.max(0, charIdx));
          if (charIdx <= 0) {
            mode = 'type';
            wordIdx = (wordIdx + 1) % words.length;
            setTimeout(tick, betweenPause);
            return;
          }
          setTimeout(tick, eraseSpeed);
        }
      };

      tick();
    };

    const typewriters = document.querySelectorAll('.typewriter');
    if (typewriters.length > 0) {
      if ('IntersectionObserver' in window) {
        const twIO = new IntersectionObserver((entries) => {
          for (const entry of entries) {
            if (entry.isIntersecting) {
              twIO.unobserve(entry.target);
              startTypewriter(entry.target);
            }
          }
        }, { threshold: 0.25 });
        typewriters.forEach((el) => twIO.observe(el));
      } else {
        // No IO support → start immediately.
        typewriters.forEach(startTypewriter);
      }
    }

    // ---------------------------------------------------------------
    // 3. Scroll-driven UI: navbar blur, progress bar, back-to-top FAB.
    //    Single rAF-throttled listener that updates all three to avoid
    //    layout thrash on fast scrolls.
    // ---------------------------------------------------------------
    {
      const navbar    = document.querySelector('[data-navbar]');
      const progress  = document.querySelector('[data-scroll-progress]');
      const backTop   = document.querySelector('[data-back-to-top]');

      let lastScrolled  = false;   // navbar .is-scrolled flag
      let lastVisible   = false;   // back-to-top .is-visible flag
      let scheduled     = false;   // rAF de-dupe

      const apply = () => {
        scheduled = false;
        const y = window.scrollY;

        // (a) Navbar blur once we leave the very top.
        if (navbar) {
          const scrolled = y > 40;
          if (scrolled !== lastScrolled) {
            navbar.classList.toggle('is-scrolled', scrolled);
            lastScrolled = scrolled;
          }
        }

        // (b) Progress bar — fraction of the document scrolled.
        //     `scrollHeight - innerHeight` is the max scrollable distance.
        if (progress) {
          const max = Math.max(
            document.documentElement.scrollHeight - window.innerHeight,
            1
          );
          const ratio = Math.min(Math.max(y / max, 0), 1);
          progress.style.setProperty('--progress', ratio.toFixed(4));
        }

        // (c) Back-to-top button — show after ~600px of scroll.
        if (backTop) {
          const visible = y > 600;
          if (visible !== lastVisible) {
            backTop.classList.toggle('is-visible', visible);
            lastVisible = visible;
          }
        }
      };

      const onScroll = () => {
        if (!scheduled) {
          scheduled = true;
          requestAnimationFrame(apply);
        }
      };

      // Run once on load so initial state is correct (refresh mid-page).
      apply();
      window.addEventListener('scroll', onScroll, { passive: true });
      window.addEventListener('resize', onScroll, { passive: true });
    }

    // ---------------------------------------------------------------
    // 3b. Mobile menu auto-close — when the user taps a link in the
    // drawer, let the browser handle the anchor navigation, then strip
    // .is-open from the toggle + menu so the drawer slides away.
    // The toggle itself is an @client component that owns React-like
    // state — we can't reach into it, so we just brute-remove the
    // class. On the next render the component will resync.
    // ---------------------------------------------------------------
    document.addEventListener('click', (e) => {
      const link = e.target && e.target.closest
        ? e.target.closest('.mobile-menu__link')
        : null;
      if (!link) return;
      // Defer to after the browser has started navigation.
      requestAnimationFrame(() => {
        const toggle = document.querySelector('.nav-toggle.is-open');
        const menu = document.querySelector('.mobile-menu.is-open');
        if (toggle) toggle.classList.remove('is-open');
        if (menu) menu.classList.remove('is-open');
      });
    });

    // ---------------------------------------------------------------
    // 3c. Command palette — Ctrl/Cmd+K (or '/') opens a search modal.
    //     The DOM is pre-rendered in <CommandPalette>; we only handle
    //     show/hide, filtering, arrow-key navigation, and dispatch.
    // ---------------------------------------------------------------
    {
      const root  = document.querySelector('[data-cmdk-root]');
      if (root) {
        const input    = root.querySelector('[data-cmdk-input]');
        const list     = root.querySelector('[data-cmdk-list]');
        const empty    = root.querySelector('[data-cmdk-empty]');
        const backdrop = root.querySelector('[data-cmdk-backdrop]');
        const items    = Array.from(root.querySelectorAll('[data-cmdk-item]'));
        let activeIdx  = 0;
        let lastFocus  = null;

        const visibleItems = () =>
          items.filter((el) => !el.classList.contains('is-hidden'));

        const setActive = (idx) => {
          const vis = visibleItems();
          if (vis.length === 0) return;
          activeIdx = ((idx % vis.length) + vis.length) % vis.length;
          items.forEach((el) => el.classList.remove('is-active'));
          const target = vis[activeIdx];
          target.classList.add('is-active');
          // Keep the active item in view inside the scrolling list.
          if (typeof target.scrollIntoView === 'function') {
            target.scrollIntoView({ block: 'nearest' });
          }
        };

        const applyFilter = () => {
          const q = (input.value || '').trim().toLowerCase();
          let firstShown = -1;
          items.forEach((el, i) => {
            const hay = el.getAttribute('data-keywords') || '';
            const match = q.length === 0 || hay.indexOf(q) !== -1;
            el.classList.toggle('is-hidden', !match);
            if (match && firstShown === -1) firstShown = i;
          });
          // Hide group labels whose group has no visible items.
          let lastLabel = null;
          let labelHasVisible = false;
          const flushLabel = () => {
            if (lastLabel) {
              lastLabel.classList.toggle('is-hidden', !labelHasVisible);
            }
          };
          Array.from(list.children).forEach((node) => {
            if (node.classList.contains('cmdk__group-label')) {
              flushLabel();
              lastLabel = node;
              labelHasVisible = false;
            } else if (node.classList.contains('cmdk__item')) {
              if (!node.classList.contains('is-hidden')) labelHasVisible = true;
            }
          });
          flushLabel();
          // Empty state.
          const vis = visibleItems();
          if (empty) empty.classList.toggle('is-visible', vis.length === 0);
          activeIdx = 0;
          setActive(0);
        };

        const open = () => {
          lastFocus = document.activeElement;
          root.classList.add('is-open');
          root.setAttribute('aria-hidden', 'false');
          document.body.style.overflow = 'hidden';
          if (input) {
            input.value = '';
            applyFilter();
            setTimeout(() => input.focus(), 30);
          }
        };

        const close = () => {
          root.classList.remove('is-open');
          root.setAttribute('aria-hidden', 'true');
          document.body.style.overflow = '';
          if (lastFocus && typeof lastFocus.focus === 'function') {
            lastFocus.focus();
          }
        };

        const isOpen = () => root.classList.contains('is-open');

        const activate = (el) => {
          if (!el) return;
          const action = el.getAttribute('data-action');
          const target = el.getAttribute('data-target');
          if (!action || !target) return;

          if (action === 'nav') {
            close();
            // Update hash so anchor scroll happens via global smooth-scroll.
            // Use replace so we don't pile up history entries.
            const el2 = document.querySelector(target);
            if (el2 && typeof el2.scrollIntoView === 'function') {
              el2.scrollIntoView({ behavior: 'smooth', block: 'start' });
              history.replaceState(null, '', target);
            } else {
              window.location.hash = target;
            }
          } else if (action === 'open') {
            close();
            // Same-origin paths (e.g. /cv.pdf) open in same tab so the
            // browser's download handler runs; external URLs new tab.
            const isExternal = /^https?:/i.test(target);
            if (isExternal) {
              window.open(target, '_blank', 'noopener,noreferrer');
            } else {
              window.location.assign(target);
            }
          } else if (action === 'copy') {
            const flash = el.querySelector('.cmdk__item-kbd');
            const originalGlyph = flash ? flash.textContent : '';
            const ok = () => {
              if (flash) {
                flash.textContent = '✓';
                setTimeout(() => { flash.textContent = originalGlyph; }, 900);
              }
              setTimeout(close, 350);
            };
            if (navigator.clipboard && navigator.clipboard.writeText) {
              navigator.clipboard.writeText(target).then(ok, ok);
            } else {
              // Legacy fallback.
              const ta = document.createElement('textarea');
              ta.value = target;
              ta.setAttribute('readonly', '');
              ta.style.position = 'absolute';
              ta.style.left = '-9999px';
              document.body.appendChild(ta);
              ta.select();
              try { document.execCommand('copy'); } catch (_) {}
              document.body.removeChild(ta);
              ok();
            }
          }
        };

        // ---- Global open shortcut ----
        document.addEventListener('keydown', (e) => {
          const cmdK =
            (e.ctrlKey || e.metaKey) && e.key && e.key.toLowerCase() === 'k';
          const slash =
            e.key === '/' &&
            !e.ctrlKey && !e.metaKey && !e.altKey &&
            !(e.target instanceof HTMLInputElement) &&
            !(e.target instanceof HTMLTextAreaElement) &&
            !(e.target && e.target.isContentEditable);
          if (cmdK || slash) {
            e.preventDefault();
            isOpen() ? close() : open();
          } else if (e.key === 'Escape' && isOpen()) {
            e.preventDefault();
            close();
          }
        });

        // ---- Backdrop click closes ----
        if (backdrop) backdrop.addEventListener('click', close);

        // ---- Input typing filters; arrow keys/Enter navigate ----
        if (input) {
          input.addEventListener('input', applyFilter);
          input.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowDown') {
              e.preventDefault();
              setActive(activeIdx + 1);
            } else if (e.key === 'ArrowUp') {
              e.preventDefault();
              setActive(activeIdx - 1);
            } else if (e.key === 'Enter') {
              e.preventDefault();
              const vis = visibleItems();
              if (vis[activeIdx]) activate(vis[activeIdx]);
            }
          });
        }

        // ---- Click an item to activate ----
        items.forEach((el) => {
          el.addEventListener('click', () => activate(el));
          el.addEventListener('mouseenter', () => {
            const vis = visibleItems();
            const idx = vis.indexOf(el);
            if (idx >= 0) setActive(idx);
          });
        });

        // Expose a global hook the navbar hint button can call.
        window.__openCmdK = open;

        // Bind any [data-open-cmdk] trigger (e.g. the ⌘K chip in the navbar).
        document.querySelectorAll('[data-open-cmdk]').forEach((el) => {
          el.addEventListener('click', (e) => {
            e.preventDefault();
            open();
          });
        });

        // Initial render — sets the first item as active.
        applyFilter();
      }
    }

    // ---------------------------------------------------------------
    // 4. ScrollSpy — highlight the active nav link
    // ---------------------------------------------------------------
    const navLinks = Array.from(
      document.querySelectorAll('[data-nav-link]')
    );
    if (navLinks.length > 0 && 'IntersectionObserver' in window) {
      // Map of "#sectionId" -> link element.
      const linkByHash = new Map(
        navLinks
          .map((a) => [a.getAttribute('href'), a])
          .filter(([h]) => h && h.startsWith('#'))
      );

      const sectionEls = Array.from(linkByHash.keys())
        .map((hash) => document.getElementById(hash.slice(1)))
        .filter(Boolean);

      // Track each section's current intersection ratio; on each update,
      // the section with the largest ratio wins.
      const ratios = new Map();
      const spy = new IntersectionObserver(
        (entries) => {
          for (const entry of entries) {
            ratios.set(entry.target.id, entry.intersectionRatio);
          }
          let bestId = null;
          let bestRatio = 0;
          for (const [id, ratio] of ratios) {
            if (ratio > bestRatio) {
              bestRatio = ratio;
              bestId = id;
            }
          }
          if (bestId) {
            for (const link of navLinks) {
              link.classList.toggle(
                'active',
                link.getAttribute('href') === '#' + bestId
              );
            }
          }
        },
        {
          rootMargin: '-30% 0px -50% 0px',
          threshold: [0, 0.25, 0.5, 0.75, 1],
        }
      );

      sectionEls.forEach((s) => spy.observe(s));
    }

    // ---------------------------------------------------------------
    // 5. 3D tilt — mousemove writes --rx / --ry; mouseleave clears them
    // ---------------------------------------------------------------
    if (!prefersReduced) {
      const tilts = document.querySelectorAll('.tilt');
      const MAX_DEG = 8;
      tilts.forEach((card) => {
        card.addEventListener('mousemove', (e) => {
          const rect = card.getBoundingClientRect();
          const px = (e.clientX - rect.left) / rect.width;  // 0..1
          const py = (e.clientY - rect.top) / rect.height;  // 0..1
          const ry = (px - 0.5) * 2 * MAX_DEG;              // left/right
          const rx = -(py - 0.5) * 2 * MAX_DEG;             // up/down
          card.style.setProperty('--rx', rx.toFixed(2) + 'deg');
          card.style.setProperty('--ry', ry.toFixed(2) + 'deg');
        });
        card.addEventListener('mouseleave', () => {
          card.style.removeProperty('--rx');
          card.style.removeProperty('--ry');
        });
      });
    }

    // ---------------------------------------------------------------
    // 5b. Magnetic CTAs — small elements lean toward the cursor.
    //     For each `.magnetic` element we compute the cursor's offset
    //     from the element's center and write it back as `--mx` / `--my`
    //     (in px). The `.magnetic` CSS class translates the element by
    //     those vars. Cleared on mouseleave so the element eases home.
    //     STRENGTH is the fraction of the (dx, dy) we apply — small so
    //     it feels like attraction, not jitter.
    // ---------------------------------------------------------------
    if (!prefersReduced) {
      const magnets = document.querySelectorAll('.magnetic');
      const STRENGTH = 0.30;
      const MAX_PX = 14;     // hard clamp so big buttons don't drift far
      magnets.forEach((el) => {
        el.addEventListener('mousemove', (e) => {
          const rect = el.getBoundingClientRect();
          const dx = (e.clientX - (rect.left + rect.width / 2)) * STRENGTH;
          const dy = (e.clientY - (rect.top + rect.height / 2)) * STRENGTH;
          const cx = Math.max(-MAX_PX, Math.min(MAX_PX, dx));
          const cy = Math.max(-MAX_PX, Math.min(MAX_PX, dy));
          el.style.setProperty('--mx', cx.toFixed(1) + 'px');
          el.style.setProperty('--my', cy.toFixed(1) + 'px');
        });
        el.addEventListener('mouseleave', () => {
          el.style.removeProperty('--mx');
          el.style.removeProperty('--my');
        });
      });
    }

    // ---------------------------------------------------------------
    // 6. Custom cursor — dot follows pointer; ring lags
    // ---------------------------------------------------------------
    const dot = document.querySelector('[data-cursor-dot]');
    const ring = document.querySelector('[data-cursor-ring]');
    const isTouch =
      window.matchMedia && window.matchMedia('(pointer: coarse)').matches;

    if (dot && ring && !isTouch && !prefersReduced) {
      let targetX = window.innerWidth / 2;
      let targetY = window.innerHeight / 2;
      let ringX = targetX;
      let ringY = targetY;

      window.addEventListener(
        'mousemove',
        (e) => {
          targetX = e.clientX;
          targetY = e.clientY;
          dot.style.transform =
            'translate3d(' + targetX + 'px,' + targetY + 'px,0) translate(-50%,-50%)';
        },
        { passive: true }
      );

      const loop = () => {
        ringX += (targetX - ringX) * 0.15;
        ringY += (targetY - ringY) * 0.15;
        ring.style.transform =
          'translate3d(' + ringX.toFixed(2) + 'px,' + ringY.toFixed(2) + 'px,0) translate(-50%,-50%)';
        requestAnimationFrame(loop);
      };
      requestAnimationFrame(loop);

      // Grow the ring over interactive elements.
      const onOver = (e) => {
        if (e.target.closest('a, button, [data-cursor-grow]')) {
          ring.classList.add('is-grow');
        }
      };
      const onOut = (e) => {
        if (e.target.closest('a, button, [data-cursor-grow]')) {
          ring.classList.remove('is-grow');
        }
      };
      document.addEventListener('mouseover', onOver);
      document.addEventListener('mouseout', onOut);
    } else if (dot && ring) {
      // Touch / reduced-motion: hide custom cursor entirely so the OS
      // cursor (or finger) remains the only pointer affordance.
      dot.style.display = 'none';
      ring.style.display = 'none';
    }
  });
})();
''';
