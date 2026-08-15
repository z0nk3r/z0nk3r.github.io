---
layout: default
title: Home
---

<main>
  {% comment %} -> docs/templates.md#hero-s-name-page-s {% endcomment %}
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
      {% comment %} -> docs/templates.md#no-email-address-published-here {% endcomment %}
      {% if site.email %}
      <a href="mailto:{{ site.email }}">
        <span>{{ site.email }}</span>
      </a>
      {% endif %}
    </div>
  </div>

  {% comment %} -> docs/templates.md#four-most-recent-posts-looped {% endcomment %}
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

  {% comment %} -> docs/templates.md#gate-filtered-list-not-file {% endcomment %}
  {% comment %} -> docs/templates.md#entries-order-integer-come-first {% endcomment %}
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
    // -> docs/pages-and-data.md#fills-github-star-count-each
    (function () {
        var badges = document.querySelectorAll('.project-stars[data-repo]');
        if (!badges.length) return;

        // -> docs/pages-and-data.md#2h-shields-serves-cache-control-max-age
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
