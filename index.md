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
  {% assign projects = site.data.projects %}
  {% if projects and projects.size > 0 %}
  <h2 class="section-heading">Featured Projects</h2>
  <ul class="posts projects">
    {% for project in projects %}
      {% include project-card.html project=project %}
    {% endfor %}
  </ul>
  {% endif %}
</main>
