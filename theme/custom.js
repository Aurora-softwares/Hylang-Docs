(function () {
    'use strict';

    var OVERRIDE_KEY  = 'hy-theme-override'; // 'light' | 'dark' | null
    var DARK_THEME    = 'coal';
    var LIGHT_THEME   = 'light';

    // ---------- helpers ----------

    function sysDark() {
        return window.matchMedia('(prefers-color-scheme: dark)').matches;
    }

    function getOverride() {
        try { return localStorage.getItem(OVERRIDE_KEY); } catch (e) { return null; }
    }

    function setOverride(val) {
        try {
            if (val === null) localStorage.removeItem(OVERRIDE_KEY);
            else              localStorage.setItem(OVERRIDE_KEY, val);
        } catch (e) {}
    }

    function mdThemeFor(override) {
        if (override === 'light') return LIGHT_THEME;
        if (override === 'dark')  return DARK_THEME;
        return sysDark() ? DARK_THEME : LIGHT_THEME;
    }

    // Use mdBook's own set_theme() when available; fall back to direct DOM manipulation.
    function applyTheme(mdTheme) {
        if (typeof window.set_theme === 'function') {
            window.set_theme(mdTheme, true);
        } else {
            try { localStorage.setItem('mdbook-theme', mdTheme); } catch (e) {}
            var html = document.documentElement;
            ['ayu', 'coal', 'light', 'navy', 'rust'].forEach(function (c) {
                html.classList.remove(c);
            });
            html.classList.add(mdTheme);
        }
    }

    // ---------- UI ----------

    function sliderVal(override) {
        if (override === 'light') return 0;
        if (override === 'dark')  return 2;
        return 1; // auto
    }

    function buildWidget() {
        var wrapper = document.createElement('span');
        wrapper.id = 'hy-theme-wrapper';
        wrapper.setAttribute('aria-label', 'Theme selector');

        // Sun icon (light end)
        var sun = document.createElement('span');
        sun.className = 'hy-theme-icon';
        sun.setAttribute('aria-hidden', 'true');
        sun.textContent = '☀'; // ☀

        // Slider
        var slider = document.createElement('input');
        slider.type  = 'range';
        slider.id    = 'hy-theme-slider';
        slider.min   = '0';
        slider.max   = '2';
        slider.step  = '1';
        slider.setAttribute('aria-label', 'Theme: 0 = Light, 1 = Auto, 2 = Dark');

        // Tick labels for browsers that support datalist on range inputs
        var ticks = document.createElement('datalist');
        ticks.id = 'hy-theme-ticks';
        ['0','1','2'].forEach(function (v) {
            var opt = document.createElement('option');
            opt.value = v;
            ticks.appendChild(opt);
        });
        slider.setAttribute('list', 'hy-theme-ticks');

        // Moon icon (dark end)
        var moon = document.createElement('span');
        moon.className = 'hy-theme-icon';
        moon.setAttribute('aria-hidden', 'true');
        moon.textContent = '☾'; // ☾

        // "auto" label — only visible when slider is in the middle
        var hint = document.createElement('span');
        hint.id = 'hy-theme-hint';

        wrapper.appendChild(sun);
        wrapper.appendChild(slider);
        wrapper.appendChild(ticks);
        wrapper.appendChild(moon);
        wrapper.appendChild(hint);
        return wrapper;
    }

    function updateHint(slider, override) {
        var hint = document.getElementById('hy-theme-hint');
        if (!hint) return;
        var isAuto = (parseInt(slider.value, 10) === 1);
        hint.textContent = isAuto ? 'auto' : '';
        hint.style.opacity = isAuto ? '1' : '0';
    }

    // ---------- init ----------

    function init() {
        // Apply the right theme immediately (set_theme may or may not be ready yet,
        // but we try — worst case the fallback applies the class directly).
        var override = getOverride();
        applyTheme(mdThemeFor(override));

        // Remove mdBook's built-in theme toggle so the two controls don't conflict.
        var mdToggle = document.getElementById('theme-toggle');
        var mdPopup  = document.querySelector('.theme-popup');
        if (mdToggle) mdToggle.style.display = 'none';
        if (mdPopup)  mdPopup.style.display  = 'none';

        // Build and inject the widget.
        var widget = buildWidget();
        var slider = widget.querySelector('#hy-theme-slider');
        slider.value = sliderVal(override);
        updateHint(slider, override);

        var target = document.querySelector('#menu-bar .left-buttons')
                  || document.querySelector('.left-buttons')
                  || document.querySelector('#menu-bar')
                  || document.body;
        target.appendChild(widget);

        // Slider interaction
        slider.addEventListener('input', function () {
            var val = parseInt(this.value, 10);
            var newOverride = val === 0 ? 'light' : val === 2 ? 'dark' : null;
            setOverride(newOverride);
            applyTheme(mdThemeFor(newOverride));
            updateHint(this, newOverride);
        });

        // React to OS-level preference changes while the page is open.
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function () {
            if (!getOverride()) {
                applyTheme(mdThemeFor(null));
                updateHint(slider, null);
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
