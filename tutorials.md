---
layout: default
title: Tutorials
permalink: /tutorials/
---

<main>
  <h1>Tutorials</h1>

  {% assign topics = site.tutorial_topics | sort_natural: "title" %}
  {% if topics.size > 0 %}
  <ul class="search-results tutorial-list">
    {% for topic in topics %}
      {% include tutorial-card.html topic=topic %}
    {% endfor %}
  </ul>
  {% else %}
  <div class="terminal-empty">
    <p class="terminal-empty__line"><span class="terminal-empty__prompt">z0nk3r@site:~$</span> ls tutorials/</p>
    <p class="terminal-empty__line terminal-empty__out">total 0 &mdash; nothing published here yet.</p>
    <p class="terminal-empty__line terminal-empty__out">tutorials are being written; check back soon.</p>
    <p class="terminal-empty__line"><span class="terminal-empty__prompt">z0nk3r@site:~$</span> <span class="terminal-empty__cursor" aria-hidden="true">&#9646;</span></p>
    <p class="terminal-empty__hint">In the meantime: <a class="inline-link" href="{{ '/blog/' | relative_url }}">blog</a> &middot; <a class="inline-link" href="{{ '/references/' | relative_url }}">references</a>.</p>
  </div>
  {% endif %}
  <!-- Render-blocking anchor for the <link rel="expect"> in default.html's
       head, same pattern as blog.md's #post-list-end: first render (and the
       view-transition capture on Back navigation) waits until every topic
       card above this marker has been parsed. Unconditional so the target
       always exists, empty state included. -->
  <span id="topic-list-end" hidden></span>
</main>
