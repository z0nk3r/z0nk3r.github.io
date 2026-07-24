---
layout: default
title: Tutorials
permalink: /tutorials/
---

<main>
  <h1>Tutorials</h1>

  {% comment %} Root topics only (parent = this index's own URL - joins are
  URL-derived, and a root topic's parent URL computes to /tutorials/ itself) -
  nested child topics render as cards on their own parent's page, not here.
  topic-children also applies the sibling sort (order:-carrying topics first,
  the rest alphabetically), and the empty-state gate keys on the FILTERED
  list so a site with only nested topics (no roots) still gets the empty
  state instead of a bare <ul>. {% endcomment %}
  {% include topic-children.html parent="/tutorials/" %}
  {% if topic_children.size > 0 %}
  <ul class="search-results tutorial-list">
    {% for topic in topic_children %}
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
