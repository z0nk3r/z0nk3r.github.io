---
layout: default
title: Home
---

<main>
  {%- comment -%}
    The hero's name is the page's ONE <h1>. The header wordmark is deliberately
    a <p class="site-title"> (not an h1) so each page owns its own single
    heading - don't promote either one without demoting the other.
  {%- endcomment -%}
  <div class="home-hero">
    <h1>{{ site.title }}</h1>
    <p class="home-hero__role">Capabilities Developer &middot; Security Researcher &middot; Perpetual Student</p>
    <p class="home-hero__blurb">
      Reverse engineering, binary exploitation, and the notes I keep while
      learning them. Writeups, reference tables, and long-form tutorials.
    </p>
    <div class="home-hero__links">
      <a href="https://github.com/{{ site.title }}" target="_blank" rel="noopener">
        {% include icon-github.html %}
        <span>github.com/{{ site.title }}</span>
      </a>
      {%- comment -%}
        No email address is published here on purpose - _config.yml has no
        `email:` field, and one should not be invented. Add
        `email: you@example.com` to _config.yml and this slot renders a mailto
        link automatically.
      {%- endcomment -%}
      {% if site.email %}
      <a href="mailto:{{ site.email }}">
        <span>{{ site.email }}</span>
      </a>
      {% endif %}
    </div>
  </div>

  {%- comment -%}
    Four most recent posts, looped directly rather than through
    posts-by-year.html - that include exists to emit year headings, which a
    short teaser should not have. .post-rows is a 2-column grid on desktop, so
    four half-width rows fill exactly two even rows with no orphan. The full
    year-grouped archive lives at /blog/.
  {%- endcomment -%}
  {% assign recent = site.posts | slice: 0, 4 %}
  {% if recent.size > 0 %}
  <h2 class="section-heading">Latest Posts</h2>
  <ul class="search-results post-rows">
    {% for post in recent %}
      {% include post-card-horizontal.html post=post %}
    {% endfor %}
  </ul>
  <p class="section-more">
    <a href="{{ '/blog/' | relative_url }}">All posts &rarr;</a>
  </p>
  {% endif %}

  {%- comment -%}
    Gate on the FILTERED list, not on the file existing - a missing or empty
    _data/projects.yml must render no heading and no empty <ul>, rather than a
    bare "Projects" heading with nothing under it.
  {%- endcomment -%}
  {%- comment -%}
    Entries WITH an `order:` integer come first, sorted by it; the rest follow
    in file order. Two lists concatenated rather than `sort: "order", "last"` -
    that is valid Liquid but compares every nil-order entry as equal under
    Ruby's unstable sort, so their relative order changes build to build. Same
    reasoning (and the same shape) as topic-children.html. Keep `order:` values
    unique for that reason.
  {%- endcomment -%}
  {% assign pj_ordered = "" | split: "" %}
  {% assign pj_rest = "" | split: "" %}
  {% for pj in site.data.projects %}
    {% if pj.order %}
      {% assign pj_ordered = pj_ordered | push: pj %}
    {% else %}
      {% assign pj_rest = pj_rest | push: pj %}
    {% endif %}
  {% endfor %}
  {% assign pj_ordered = pj_ordered | sort: "order" %}
  {% assign projects = pj_ordered | concat: pj_rest %}
  {% if projects and projects.size > 0 %}
  <h2 class="section-heading">Featured Projects</h2>
  <ul class="posts projects">
    {% for project in projects %}
      {% include project-card.html project=project %}
    {% endfor %}
  </ul>
  {% endif %}
</main>

<script>
    // Fills in the GitHub star count on each project card.
    //
    // The source is shields.io, NOT api.github.com, and that is the whole point.
    // Unauthenticated GitHub allows 60 requests per hour PER VISITOR IP, and
    // this page spends one per project - so a handful of reloads, or a shared
    // corporate/mobile IP, exhausted it and every badge silently vanished.
    // Worse, GitHub returned 403 to browser requests while curl from the same
    // IP in the same minute still got 200, so the quota arithmetic could not
    // even be reasoned about. shields.io caches server-side, serves
    // `access-control-allow-origin: *`, and costs the visitor no quota at all.
    //
    // Trade-off worth knowing: shields pre-formats big numbers and rounds them
    // (115150 -> "115k", where this page previously showed "115.1k"). Below
    // 1000 it is the exact count, so this only bites once a repo takes off. If
    // the tenths ever matter, the fix is to bake counts at build time via an
    // Actions workflow rather than to go back to calling GitHub from the page.
    //
    // Every failure path still leaves the badge hidden rather than showing a
    // zero or a broken chip.
    (function () {
        var badges = document.querySelectorAll('.project-stars[data-repo]');
        if (!badges.length) return;

        // 2h. shields serves `cache-control: max-age=1800, s-maxage=1800` from a
        // Cloudflare edge, so its own data is never fresher than 30 minutes -
        // a shorter TTL than that would just refetch an identical value. There
        // is no published per-IP limit and a 15-request burst returned 200
        // every time, so the request volume is not the constraint here; 2h is
        // simply a sensible multiple of their cache window. The browser's own
        // HTTP cache honours the same header underneath this.
        var TTL_MS = 2 * 60 * 60 * 1000;

        function reveal(el, text) {
            el.querySelector('.project-stars__count').textContent = text;
            el.removeAttribute('hidden');
        }

        badges.forEach(function (el) {
            var repo = el.getAttribute('data-repo');
            var key = 'gh-stars:' + repo;

            try {
                var cached = JSON.parse(localStorage.getItem(key) || 'null');
                if (cached && (Date.now() - cached.t) < TTL_MS) {
                    reveal(el, cached.n);
                    return;
                }
            } catch (e) { /* unparseable or storage blocked - just refetch */ }

            fetch('https://img.shields.io/github/stars/' + repo + '.json')
                .then(function (res) {
                    if (!res.ok) throw new Error('HTTP ' + res.status);
                    return res.json();
                })
                .then(function (data) {
                    // shields returns the already-formatted string in `value`
                    var text = data && data.value;
                    if (typeof text !== 'string' || !text) throw new Error('no value');
                    try {
                        localStorage.setItem(key, JSON.stringify({ n: text, t: Date.now() }));
                    } catch (e) { /* private mode - render anyway, just uncached */ }
                    reveal(el, text);
                })
                .catch(function () { /* leave the badge hidden */ });
        });
    })();
</script>
