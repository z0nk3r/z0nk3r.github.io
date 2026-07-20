---
layout: default
title: Authors
permalink: /authors/
---

<nav class="breadcrumbs" aria-label="Breadcrumb">
    <a href="{{ '/' | relative_url }}"><span class="crumb-icon" aria-hidden="true">⌂</span>Home</a>
    <span> / </span>
    <span><span class="crumb-icon" aria-hidden="true">●●</span>Authors</span>
</nav>

<main>
  <h1>Authors</h1>
  <ul class="author-list">
    {% for author in site.authors %}
    <li>
      <a class="author-list-item" href="{{ author.url | relative_url }}">
        <div class="author-header__avatar">
          <img src="{{ author.avatar }}" alt="{{ author.name }}">
        </div>
        <div class="author-header__info">
          <h2>{{ author.name }}</h2>
          {% if author.bio %}<p>{{ author.bio }}</p>{% endif %}
          {% if author.github %}
          {% comment %} aria-label on a plain, non-interactive span has no
          effect for assistive tech (it only applies to focusable elements
          or ones with an ARIA role that supports naming) - this icon is
          purely decorative here anyway (the whole card is already one link
          to the author's own page, not to GitHub directly), so dropped
          rather than left as dead weight. {% endcomment %}
          <span class="icon-link">{% include icon-github.html %}</span>
          {% endif %}
        </div>
      </a>
    </li>
    {% endfor %}
  </ul>
</main>
