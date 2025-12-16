---
layout: tech-bite-list
title: "Tech Bites"
description: "Daily tech insights and discoveries from the world of web development"
---

{{ site.content.pages.tech_bites.list_page.welcome_message | default: "Welcome to my collection of tech insights!" }} {{ site.content.pages.tech_bites.list_page.intro_text | default: "Here you'll find bite-sized posts covering everything from JavaScript tips to performance optimization techniques, accessibility best practices, and modern web development workflows." }}

{{ site.content.pages.tech_bites.list_page.description | default: "Each post is designed to be a quick read while providing practical, actionable information that you can apply to your own projects. Whether you're a seasoned developer or just starting out, there's something here for everyone." }}

## {{ site.content.pages.tech_bites.list_page.categories_title | default: "Categories" }}

{% for category in site.content.pages.tech_bites.list_page.categories %}
- **{{ category.name }}** - {{ category.description }}
{% endfor %}

{{ site.content.pages.tech_bites.list_page.closing_text | default: "Browse through the posts below, or use the category filter to find content that interests you most." }}
