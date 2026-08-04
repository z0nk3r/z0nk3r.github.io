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
    // Client-side because GitHub Pages builds with no plugins, so there is no
    // build-time way to call an API. Unauthenticated api.github.com allows 60
    // requests per hour PER VISITOR IP, so results are cached in localStorage
    // and only refetched once the TTL expires - without that, a visitor who
    // reloads a few times would exhaust their own quota and see the badges
    // vanish.
    //
    // Every failure path (rate limit, offline, private or renamed repo) leaves
    // the badge hidden rather than showing a zero or an error.
    (function () {
        var badges = document.querySelectorAll('.project-stars[data-repo]');
        if (!badges.length) return;

        var TTL_MS = 6 * 60 * 60 * 1000;

        // GitHub-style short form, but TRUNCATED rather than rounded, so a
        // count never reads higher than it is: 32760 -> "32.7k", not "32.8k".
        // Math.floor on tenths is what does it; toFixed(1) alone would round up.
        // The trailing .0 is kept deliberately ("1.0k", not "1k") so every
        // abbreviated count has the same shape and the badges stay visually
        // aligned across cards.
        // No M suffix on purpose - the largest repo on GitHub is a few hundred
        // thousand stars, which "404.2k" already covers.
        function shorten(n) {
            if (n < 1000) return String(n);
            return (Math.floor(n / 100) / 10).toFixed(1) + 'k';
        }

        function reveal(el, count) {
            el.querySelector('.project-stars__count').textContent = shorten(count);
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

            fetch('https://api.github.com/repos/' + repo, {
                headers: { 'Accept': 'application/vnd.github+json' }
            })
                .then(function (res) {
                    if (!res.ok) throw new Error('HTTP ' + res.status);
                    return res.json();
                })
                .then(function (data) {
                    if (typeof data.stargazers_count !== 'number') throw new Error('no count');
                    try {
                        localStorage.setItem(key, JSON.stringify({
                            n: data.stargazers_count, t: Date.now()
                        }));
                    } catch (e) { /* private mode - render anyway, just uncached */ }
                    reveal(el, data.stargazers_count);
                })
                .catch(function () { /* leave the badge hidden */ });
        });
    })();
</script>
