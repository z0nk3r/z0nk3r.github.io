---
layout: default
title: Blog
permalink: /blog/
---

<main>
  <h1>Blog</h1>

  {% include posts-by-year.html posts=site.posts %}
  <!-- Render-blocking anchor for the <link rel="expect"> in default.html's
       head: first render (and the view-transition capture on Back
       navigation) waits until everything above this marker - every post
       card - has been parsed. -->
  <span id="post-list-end" hidden></span>
</main>
