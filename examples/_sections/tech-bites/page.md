---
layout: post-list
title: "Tech Bites"
description: "Daily tech insights and discoveries"
section: "tech-bites"
permalink: /tech-bites/
---

This is an example Tech Bites listing page. Posts with `section: "tech-bites"` in their front matter will appear here.

To create a new post, add a markdown file to `_posts/` with the following front matter:

```yaml
---
layout: post
title: "Your Post Title"
date: 2024-01-01
section: "tech-bites"
categories: [ai]  # Use lowercase keys that match filter_categories in config.yml
---

Your post content here...
```

**Note:** The `categories` array should use lowercase keys that match the `key` values defined in `filter_categories` in this section's `config.yml` file. For example, if your config has `key: "ai"`, use `categories: [ai]` in your post.

