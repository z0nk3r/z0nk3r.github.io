// Faint ASCII "matrix rain" background effect, rendered on a full-viewport canvas.
(function () {
    var canvas = document.getElementById('ascii-bg');
    if (!canvas) return;

    var MOBILE_BREAKPOINT = 768;
    var CELL_SIZE = 16;
    var CHARS = '01ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*+-=<>/\\|~';
    var TICK_MS = 60;
    var GLYPH_ALPHA = 0.18;
    var FADE_ALPHA = 0.15;
    var MIN_SPEED = 0.4;
    var MAX_SPEED = 1.2;
    var ACTIVE_RATIO = 0.4;
    // A column re-rolls "active" every time it falls off the bottom, so a column that
    // keeps winning that roll can stay busy indefinitely and the background never gets
    // a quiet moment. Force a full wipe-and-restart per column on this cadence instead,
    // staggered per column so resets don't all happen in visible unison.
    var MIN_LIFETIME_MS = 20000;
    var MAX_LIFETIME_MS = 40000;

    var ctx = canvas.getContext('2d');
    var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    var cols, rows, dpr, cssWidth, cssHeight;
    var columns = []; // { y, speed, active, lastRow, resetAt }
    var fgRgb = '253, 246, 227';
    var bgRgb = '0, 0, 0';
    var tickTimer = null;

    function randomChar() {
        return CHARS[Math.floor(Math.random() * CHARS.length)];
    }

    function randomSpeed() {
        return MIN_SPEED + Math.random() * (MAX_SPEED - MIN_SPEED);
    }

    function isMobile() {
        return window.innerWidth <= MOBILE_BREAKPOINT;
    }

    function readThemeColors() {
        var style = getComputedStyle(document.documentElement);
        fgRgb = style.getPropertyValue('--foreground-rgb').trim() || fgRgb;
        bgRgb = style.getPropertyValue('--background-rgb').trim() || bgRgb;
    }

    function randomLifetime() {
        return MIN_LIFETIME_MS + Math.random() * (MAX_LIFETIME_MS - MIN_LIFETIME_MS);
    }

    function makeColumn() {
        return {
            y: -Math.random() * rows,
            speed: randomSpeed(),
            active: Math.random() < ACTIVE_RATIO,
            lastRow: null,
            resetAt: performance.now() + randomLifetime(),
            wiping: false,
            wipeY: 0
        };
    }

    function buildColumns() {
        columns = new Array(cols);
        for (var c = 0; c < cols; c++) {
            columns[c] = makeColumn();
        }
    }

    function drawStaticFrame() {
        readThemeColors();
        ctx.clearRect(0, 0, cssWidth, cssHeight);
        ctx.fillStyle = 'rgba(' + fgRgb + ', ' + GLYPH_ALPHA + ')';
        for (var c = 0; c < cols; c++) {
            if (Math.random() >= ACTIVE_RATIO) continue;
            var row = Math.floor(Math.random() * rows);
            ctx.fillText(randomChar(), c * CELL_SIZE, row * CELL_SIZE);
        }
    }

    function resize() {
        dpr = window.devicePixelRatio || 1;
        cssWidth = window.innerWidth;
        cssHeight = window.innerHeight;
        canvas.width = cssWidth * dpr;
        canvas.height = cssHeight * dpr;
        canvas.style.width = cssWidth + 'px';
        canvas.style.height = cssHeight + 'px';
        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        ctx.font = CELL_SIZE + 'px var(--font-mono, monospace)';
        ctx.textBaseline = 'top';

        cols = Math.ceil(cssWidth / CELL_SIZE);
        rows = Math.ceil(cssHeight / CELL_SIZE);
        buildColumns();
        ctx.clearRect(0, 0, cssWidth, cssHeight);
        if (reduceMotion) drawStaticFrame();
    }

    function tick() {
        readThemeColors();
        var now = performance.now();

        // Fade the previous frame toward the page background instead of clearing,
        // which is what leaves each column's falling glyph trailing behind it.
        ctx.fillStyle = 'rgba(' + bgRgb + ', ' + FADE_ALPHA + ')';
        ctx.fillRect(0, 0, cssWidth, cssHeight);

        ctx.fillStyle = 'rgba(' + fgRgb + ', ' + GLYPH_ALPHA + ')';
        for (var c = 0; c < cols; c++) {
            var col = columns[c];

            // A column re-rolls "active" every time it naturally falls off the bottom,
            // so it can keep raining indefinitely if it keeps winning that roll. Force
            // a wipe of its whole strip on a timer so every column gets a clean,
            // glyph-free break periodically regardless of how its falls have gone. The
            // wipe sweeps down at the column's own fall speed (not a separate constant),
            // so the erase trails the head at the exact pace it fell - reading as one
            // continuous "snake" of a fixed length moving downward, rather than a wipe
            // that catches up or falls behind the original motion.
            if (col.wiping) {
                ctx.clearRect(c * CELL_SIZE, col.wipeY * CELL_SIZE, CELL_SIZE, col.speed * CELL_SIZE);
                col.wipeY += col.speed;
                if (col.wipeY >= rows) {
                    Object.assign(col, makeColumn());
                }
                continue;
            }
            if (now >= col.resetAt) {
                col.wiping = true;
                col.wipeY = 0;
                continue;
            }

            col.y += col.speed;
            var row = Math.floor(col.y);
            // Only draw when the head has actually moved into a new row - otherwise
            // a slow column (speed < 1) redraws the same cell every tick, which
            // stacks alpha on top of itself and reads as far denser than intended.
            if (col.active && row !== col.lastRow && row >= 0 && row < rows) {
                ctx.fillText(randomChar(), c * CELL_SIZE, row * CELL_SIZE);
                col.lastRow = row;
            }
            if (row - rows > 10) {
                // Route through the same wipe sweep used by the lifetime-expiry reset
                // instead of instantly re-rolling - a column must finish clearing its
                // own strip before it's eligible to become active again, otherwise a
                // new stream could start while the old trail is still fading out.
                col.wiping = true;
                col.wipeY = 0;
            }
        }
    }

    function startTimer() {
        stopTimer();
        if (reduceMotion) return;
        tickTimer = window.setInterval(tick, TICK_MS);
    }

    function stopTimer() {
        if (tickTimer) { window.clearInterval(tickTimer); tickTimer = null; }
    }

    function updateVisibility() {
        if (isMobile()) {
            stopTimer();
            canvas.style.display = 'none';
            return;
        }
        canvas.style.display = '';
        resize();
        startTimer();
    }

    var resizeDebounce = null;
    window.addEventListener('resize', function () {
        window.clearTimeout(resizeDebounce);
        resizeDebounce = window.setTimeout(updateVisibility, 150);
    });

    document.addEventListener('visibilitychange', function () {
        if (document.hidden) {
            stopTimer();
        } else if (!isMobile()) {
            startTimer();
        }
    });

    window.addEventListener('themechange', function () {
        if (reduceMotion) {
            drawStaticFrame();
            return;
        }
        // The canvas's own alpha channel only ever increases via the per-tick fade-fill
        // (nothing resets it except a column's periodic wipe passing through), so a
        // region that's sat near-opaque for a while has the *old* theme's background
        // color effectively baked in. Left alone, that only repaints through the slow
        // fade, which reads as a visible "ghosting"/striping artifact for a few seconds
        // right after a toggle. Clearing immediately avoids that - the next tick just
        // starts drawing fresh with the new theme's colors already in place.
        ctx.clearRect(0, 0, cssWidth, cssHeight);
    });

    updateVisibility();
})();
