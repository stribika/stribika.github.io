---
layout: default
permalink: /pocorgtfo/
title: PoC||GTFO
---

<div class="home">
  <h1>PoC||GTFO mirror</h1>
  <dl>
    <dt>Download all</dt>
    <dd>
      <a href="magnet:?xt=urn:btmh:12207b07c0a01ae13efb5a75044e794451955b6cbf67bdcab1ffa6d03a31fc380253&tr=udp%3A//tracker.stribik.technology%3A6969&ws=https%3A//blog.stribik.technology/assets/&dn=pocorgtfo">🧲</a>
      <a href="/assets/pocorgtfo/pocorgtfo.torrent">Torrent</a>
    </dd>
  </dl>
  {% for post in site.pocorgtfo reversed %}
  <article class="external">
    <h2>
      {% if post.asset_url %}
      <a class="post-link" href="/assets{{ post.asset_url }}" target="_blank">{{ post.title }}</a>
      {% else %}
      <a class="post-link" href="{{ post.url }}">{{ post.title }}</a>
      {% endif %}
    </h2>
    {% if post.subtitle %}
    <h3>{{ post.subtitle }}</h3>
    {% endif %}
    <time class="post-meta">{{ post.date | date: "%Y-%m-%d" }}</time>
    <p>{{ post.excerpt }}</p>
    <dl>
      {% if post.magnet_url or post.torrent_url %}
      <dt>Download</dt>
      <dd>
        {% if post.magnet_url %}
        <a href="{{ post.magnet_url }}">🧲</a>
        {% endif %}
        {% if post.torrent_url %}
        <a href="/assets{{ post.torrent_url }}">Torrent</a>
        {% endif %}
      </dd>
      {% endif %}
      {% for tag in post.tags %}
      <dt>{{ tag.key }}</dt>
      <dd>{{ tag.value }}</dd>
      {% endfor %}
    </dl>
  </article>
  {% endfor %}
</div>
