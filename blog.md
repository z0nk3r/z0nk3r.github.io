---
layout: default
title: Blog
permalink: /blog/
---

<main>
    <h1>Blog</h1>

    {%- include posts-by-year.html posts=site.posts %}
    {%- comment %} -> docs/templates.md#render-blocking-anchor-link-rel-expect {% endcomment %}
    <span id="post-list-end" hidden></span>
</main>
