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
      {% if post.categories.size > 0 %}
        {% for category in post.categories %}
        <a href="{{ '/category/' | append: category | relative_url }}" class="post-category">{{ category }}</a>
        {% endfor %}
      {% endif %}
    </p>
    <div class="post-excerpt">
      {% if post.feature_image %}
        <img src="{{ post.feature_image | relative_url }}" alt="{{ post.title }}" class="featured-image">
      {% elsif post.content contains '![' %}
        {% assign image_start = post.content | split: '![' | first | size %}
        {% assign image_content = post.content | slice: image_start, post.content.size %}
        {% assign image_end = image_content | split: ')' | first | size | plus: 1 %}
        {% assign image_tag = image_content | slice: 0, image_end %}
        
        {% if image_tag contains '(' and image_tag contains ')' %}
          {% assign image_url_start = image_tag | split: '(' | last %}
          {% assign image_url = image_url_start | split: ')' | first %}
          <img src="{{ image_url | relative_url }}" alt="{{ post.title }}" class="featured-image">
        {% endif %}
      {% endif %}
      {{ post.excerpt | remove: '<p>' | remove: '</p>' }}
    </div>
  </article>
  {% endfor %}
</div> 