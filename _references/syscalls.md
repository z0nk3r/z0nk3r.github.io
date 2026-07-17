---
layout: reference
title: "Linux Syscalls"
excerpt: "Syscall calling-convention tables, one per architecture: which register holds the syscall number, the return value, and each argument."
tags: [linux, c, lookup]
permalink: /references/syscalls/
---

<ul class="posts">
{% assign syscall_archs = site.references | where_exp: "r", "r.syscalls_arch" %}
{% for reference in syscall_archs %}
  {% include reference-card.html reference=reference %}
{% endfor %}
</ul>
