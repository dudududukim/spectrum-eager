---
layout: post-list
title: "Hobbies"
description: "Personal interests and activities"
section: "hobbies"
permalink: /hobbies/
---

This is an example Hobbies listing page. Posts with `section: "hobbies"` in their front matter will appear here.

To create a new post, add a markdown file to `_posts/` with the following front matter:

```yaml
---
layout: post
title: "Your Post Title"
date: 2024-01-01
section: "hobbies"
categories: [reading]  # Use lowercase keys that match filter_categories in config.yml
---

Your post content here...
```

**Note:** The `categories` array should use lowercase keys that match the `key` values defined in `filter_categories` in this section's `config.yml` file. For example, if your config has `key: "reading"`, use `categories: [reading]` in your post.

