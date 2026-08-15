// Faint ASCII "matrix rain" background effect, rendered on a full-viewport canvas.
(function () {
    var canvas = document.getElementById('ascii-bg');
    if (!canvas) return;

    var MOBILE_BREAKPOINT = 768;
    var CELL_SIZE = 16;
    var CHARS = '01ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*+-=<>/\\|~';
    var TICK_MS = 60;
    var GLYPH_ALPHA = 0.18;
    // -> docs/ascii-background.md#every-glyph-ever-drawn-once
    var HEAD_ALPHA = GLYPH_ALPHA * 2;
    var FADE_ALPHA = 0.15;
    var MIN_SPEED = 0.4;
    var MAX_SPEED = 1.2;
    var ACTIVE_RATIO = 0.4;
    // -> docs/ascii-background.md#column-re-rolls-active-every-time
    var MIN_LIFETIME_MS = 20000;
    var MAX_LIFETIME_MS = 40000;

    var ctx = canvas.getContext('2d');
    var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    var cols, rows, dpr, cssWidth, cssHeight;
    var columns = []; // { y, speed, active, lastRow, resetAt, wiping, wipeY }
    var fgRgb = '253, 246, 227';
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
    }

    // -> docs/ascii-background.md#canvas-2d-s-ctx-font
    function resolveMonoFontFamily() {
        return getComputedStyle(document.body).fontFamily || 'monospace';
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
        ctx.font = CELL_SIZE + 'px ' + resolveMonoFontFamily();
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

        // -> docs/ascii-background.md#fade-previous-frame-eroding-own
        ctx.globalCompositeOperation = 'destination-out';
        ctx.fillStyle = 'rgba(0, 0, 0, ' + FADE_ALPHA + ')';
        ctx.fillRect(0, 0, cssWidth, cssHeight);
        ctx.globalCompositeOperation = 'source-over';

        ctx.fillStyle = 'rgba(' + fgRgb + ', ' + HEAD_ALPHA + ')';
        for (var c = 0; c < cols; c++) {
            var col = columns[c];

            // -> docs/ascii-background.md#column-re-rolls-active-every-time-2
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
            // -> docs/ascii-background.md#draw-when-head-actually-moved
            if (col.active && row !== col.lastRow && row >= 0 && row < rows) {
                ctx.fillText(randomChar(), c * CELL_SIZE, row * CELL_SIZE);
                col.lastRow = row;
            }
            if (row - rows > 10) {
                // -> docs/ascii-background.md#route-through-same-wipe-sweep
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
        // -> docs/ascii-background.md#existing-glyphs-canvas-still-painted
        ctx.clearRect(0, 0, cssWidth, cssHeight);
    });

    updateVisibility();
})();
