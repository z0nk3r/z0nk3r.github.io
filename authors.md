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
        <span class="card-glow" aria-hidden="true"></span>
        <div class="author-header__avatar">
          <img src="{{ author.avatar }}" alt="{{ author.name }}">
        </div>
        <div class="author-header__info">
          <h2>{{ author.name }}</h2>
          {% if author.bio %}<p>{{ author.bio }}</p>{% endif %}
          {% if author.github %}
          {% comment %} -> docs/templates.md#aria-label-plain-non-interactive-span-no {% endcomment %}
          <span class="icon-link">{% include icon-github.html %}</span>
          {% endif %}
        </div>
      </a>
    </li>
    {% endfor %}
  </ul>
</main>
