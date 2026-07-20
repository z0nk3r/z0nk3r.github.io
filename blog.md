---
layout: default
title: Blog
permalink: /blog/
---

<main>
  <h1>Blog</h1>

  {% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}
  {% for year_group in posts_by_year %}
  <h2 class="year-heading">{{ year_group.name }}</h2>
  <ul class="posts">
    {% for post in year_group.items %}
      {% include post-card.html post=post %}
    {% endfor %}
  </ul>
  {% endfor %}
  <!-- Render-blocking anchor for the <link rel="expect"> in default.html's
       head: first render (and the view-transition capture on Back
       navigation) waits until everything above this marker - every post
       card - has been parsed. -->
  <span id="post-list-end" hidden></span>
</main>
