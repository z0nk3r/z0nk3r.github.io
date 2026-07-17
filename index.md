---
layout: default
title: Home
---

<main>
  <h1>Latest Posts</h1>

  {% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}
  {% for year_group in posts_by_year %}
  <h2 class="year-heading">{{ year_group.name }}</h2>
  <ul class="posts">
    {% for post in year_group.items %}
      {% include post-card.html post=post %}
    {% endfor %}
  </ul>
  {% endfor %}
</main>
