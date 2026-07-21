---
layout: default
title: Tags
permalink: /tags/
---

<main>
  <h1>Tags</h1>

  <div class="tag-search-wrap">
    <input type="search" id="tagSearch" class="tag-search" placeholder="Search tags…" aria-label="Search tags" autocomplete="off">
  </div>

  {% assign all_tagged = site.posts | concat: site.references | concat: site.data.external_references | concat: site.tutorial_topics %}
  {% assign all_tags = "" | split: "," %}
  {% for item in all_tagged %}
    {% for t in item.tags %}
      {% unless all_tags contains t %}{% assign all_tags = all_tags | push: t %}{% endunless %}
    {% endfor %}
    {% for c in item.categories %}
      {% unless all_tags contains c %}{% assign all_tags = all_tags | push: c %}{% endunless %}
    {% endfor %}
  {% endfor %}
  {% assign all_tags = all_tags | sort %}
  {% assign all_references = site.references | concat: site.data.external_references %}

  <div class="badge-row tag-cloud" id="tagCloud">
    {% for t in all_tags %}
      {% assign posts_by_tag = site.posts | where_exp: "post", "post.tags contains t" %}
      {% assign posts_by_cat = site.posts | where_exp: "post", "post.categories contains t" %}
      {% assign refs_by_tag = all_references | where_exp: "ref", "ref.tags contains t" %}
      {% assign refs_by_cat = all_references | where_exp: "ref", "ref.categories contains t" %}
      {% assign topics_by_tag = site.tutorial_topics | where_exp: "tp", "tp.tags contains t" %}
      {% assign topics_by_cat = site.tutorial_topics | where_exp: "tp", "tp.categories contains t" %}
      {% assign matching_posts = posts_by_tag | concat: posts_by_cat | uniq %}
      {% assign matching_refs = refs_by_tag | concat: refs_by_cat | uniq %}
      {% assign matching_topics = topics_by_tag | concat: topics_by_cat | uniq %}
      {% assign count = matching_posts.size | plus: matching_refs.size | plus: matching_topics.size %}
      <a href="{{ '/tags/' | relative_url }}{{ t | slugify }}/" class="badge tag-chip" data-tag="{{ t | downcase }}">{{ t }}<span class="tag-count">{{ count }}</span></a>
    {% endfor %}
  </div>

  <p class="tag-empty" id="tagEmpty" hidden>No matching tags.</p>
</main>

<script>
  (function () {
    var input = document.getElementById('tagSearch');
    var chips = Array.prototype.slice.call(document.querySelectorAll('.tag-chip'));
    var empty = document.getElementById('tagEmpty');

    input.addEventListener('input', function () {
      var query = input.value.trim().toLowerCase();
      var visibleCount = 0;
      chips.forEach(function (chip) {
        var matches = chip.getAttribute('data-tag').indexOf(query) !== -1;
        chip.style.display = matches ? '' : 'none';
        if (matches) visibleCount++;
      });
      empty.hidden = visibleCount !== 0;
    });
  })();
</script>
