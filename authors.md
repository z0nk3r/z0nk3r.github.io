---
layout: default
title: Authors
permalink: /authors/
---

<div class="breadcrumbs">
    <a href="{{ '/' | relative_url }}"><span class="crumb-icon" aria-hidden="true">⌂</span>Home</a>
    <span> / </span>
    <span><span class="crumb-icon" aria-hidden="true">●●</span>Authors</span>
</div>

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
          <span class="icon-link" aria-label="GitHub">{% include icon-github.html %}</span>
          {% endif %}
        </div>
      </a>
    </li>
    {% endfor %}
  </ul>
</main>
