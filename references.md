---
layout: default
title: References
permalink: /references/
---

<main>
  <h1>References</h1>
  <ul class="posts">
    {% assign all_references = site.references | concat: site.data.external_references %}
    {% assign all_references = all_references | where_exp: "r", "r.hidden_from_index != true" %}
    {% for reference in all_references %}
      {% include reference-card.html reference=reference %}
    {% endfor %}
  </ul>
</main>
