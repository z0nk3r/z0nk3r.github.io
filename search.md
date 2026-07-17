---
layout: default
title: Search
permalink: /search/
---

<main>
  <h1>Search</h1>
  <div id="searchResults"></div>
</main>

<script>
  (function () {
    var resultsEl = document.getElementById('searchResults');
    var params = new URLSearchParams(window.location.search);
    var query = (params.get('q') || '').trim().toLowerCase();

    if (!query) {
      resultsEl.innerHTML = '<p class="search-empty">Enter a search term above to find posts.</p>';
      return;
    }

    fetch('{{ "/search-index.json" | relative_url }}')
      .then(function (r) { return r.json(); })
      .then(function (data) {
        var titleMatches = [];
        var bodyMatches = [];

        data.forEach(function (item) {
          var titleHit = item.title.toLowerCase().indexOf(query) !== -1;
          var bodyHit = item.content.toLowerCase().indexOf(query) !== -1;
          if (titleHit) {
            titleMatches.push(item);
          } else if (bodyHit) {
            bodyMatches.push(item);
          }
        });

        var results = titleMatches.concat(bodyMatches);

        if (results.length === 0) {
          resultsEl.innerHTML = '<p class="search-empty">No results for “' + query.replace(/</g, '&lt;') + '”.</p>';
          return;
        }

        var html = '<ul class="search-results">';
        results.forEach(function (item) {
          var imageBlock = item.image
            ? '<div class="search-result__image-wrap"><img src="' + item.image + '" alt="' + escapeHtml(item.title) + '" loading="lazy"></div>'
            : '<div class="search-result__image-wrap search-result__image-wrap--placeholder"><span>No Image Found</span></div>';

          var avatarBlock = item.authorAvatar
            ? '<div class="avatar avatar--photo"><img src="' + item.authorAvatar + '" alt="' + escapeHtml(item.author) + '"></div>'
            : '<div class="avatar">' + escapeHtml(item.author.slice(0, 1).toUpperCase()) + '</div>';

          html += '<li class="search-result">' +
            '<a href="' + item.url + '">' +
            imageBlock +
            '<div class="search-result__body">' +
            '<h2>' + escapeHtml(item.title) + '</h2>' +
            '<div class="byline search-result__byline">' + avatarBlock + '<span>' + escapeHtml(item.author) + '</span><span class="byline-sep">|</span><time>' + escapeHtml(item.date) + '</time></div>' +
            '<p>' + escapeHtml(item.excerpt || item.content.slice(0, 200)) + '</p>' +
            '</div>' +
            '</a>' +
            '</li>';
        });
        html += '</ul>';
        resultsEl.innerHTML = html;
      });

    function escapeHtml(str) {
      var div = document.createElement('div');
      div.textContent = str;
      return div.innerHTML;
    }
  })();
</script>
