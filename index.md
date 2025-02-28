---
layout: default
title: Home
---

<div class="post-list">
  {% for post in site.posts %}
  <article class="post-preview">
    <h2>
      <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h2>
    <p class="post-meta">
      {{ post.date | date: "%B %-d, %Y" }}
    </p>
    <div class="post-excerpt">
      {{ post.excerpt }}
    </div>
  </article>
  {% endfor %}
</div> 