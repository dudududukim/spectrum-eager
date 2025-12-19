# Spectrum-Eager Jekyll Theme

A minimal, section-based Jekyll theme for personal websites and blogs.

## Quick Start with Remote Theme

### 1. Create a New Jekyll Site

```bash
jekyll new my-awesome-site
cd my-awesome-site
```

### 2. Run Setup Script

```bash
curl -sSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh | bash -s v2.0.7
```

This will automatically:
- Download required plugin (`_plugins/sections_generator.rb`)
- Create example section configurations
- Set up the necessary folder structure

### 3. Configure Your Site

Edit `_config.yml`:

```yaml
# Remote Theme Configuration
remote_theme: dudududukim/spectrum-eager@v2.0.7

# Your site settings
url: "https://your-username.github.io"
baseurl: "" # or "/your-repo-name" for project pages

site:
  title: "Your Site Title"
  description: "Your site description"
  author: "Your Name"
```

### 4. Update Gemfile

Add to your `Gemfile`:

```ruby
group :jekyll_plugins do
  gem "jekyll-remote-theme", "0.4.3"
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
end
```

### 5. Install and Run

```bash
bundle install
bundle exec jekyll serve
```

Visit `http://localhost:4000` in your browser!

## Manual Setup

If you prefer manual setup, see [USAGE.md](USAGE.md) for detailed instructions.

## Features

- **Section-based architecture**: Organize content by sections (tech-bites, 3d-printing, etc.)
- **YAML-first configuration**: Customize everything through YAML files
- **Automatic section discovery**: Sections are automatically discovered from `_sections/` folder
- **Remote theme support**: Use the theme without forking the repository
- **Responsive design**: Mobile-friendly layouts
- **SEO optimized**: Built-in SEO tags and sitemap

## Project Structure

### User Site (Your Repository)

```
your-site/
├── _config.yml              # Site configuration
├── _plugins/                 # REQUIRED: Plugin folder
│   └── sections_generator.rb # REQUIRED: Auto-loads section configs
├── _posts/                   # Blog posts
├── _films/                   # Photography entries
├── _sections/               # Section configurations
│   ├── tech-bites/
│   │   ├── config.yml       # Section settings
│   │   └── page.md          # Section listing page
│   └── 3d-printing/
│       ├── config.yml
│       └── page.md
├── index.md                  # Homepage
├── films.md                   # Films page
└── assets/images/            # Your images
```

### Theme Files (Auto-loaded from Remote)

- `_layouts/` - Page layouts
- `_includes/` - Reusable components
- `_sass/` - Stylesheets
- `assets/css/` - Compiled CSS
- `assets/js/` - JavaScript files

## Adding Content

### Blog Posts

Create files in `_posts/` with front matter:

```yaml
---
layout: post
title: "My First Post"
date: 2025-01-01
section: "tech-bites"  # Section name
categories: ["Development"]
tags: ["jekyll", "github-pages"]
---
```

### Sections

1. Create `_sections/<name>/config.yml`:
```yaml
title: "My Section"
key: "my-section"
description: "Section description"
button_text: "View All"
button_url: "/my-section/"
type: "tech-bites-preview"
enabled: true
main_page_count: 3
```

2. Create `_sections/<name>/page.md`:
```markdown
---
layout: post-list
title: "My Section"
section: "my-section"
permalink: /my-section/
---
```

3. Add posts with `section: "my-section"` in front matter

## Configuration

### Site Settings (`_config.yml`)

See `test/_config.yml` for a complete example configuration.

### Section Settings (`_sections/<name>/config.yml`)

- `title`: Section display name
- `key`: Section identifier (must match `section` in posts)
- `description`: Section description
- `button_text`: "View All" button text
- `button_url`: Section listing page URL
- `type`: Section type (`tech-bites-preview`, etc.)
- `enabled`: Enable/disable section
- `main_page_count`: Number of posts to show on homepage
- `pagination`: Posts per page in listing
- `show_dates`: Show post dates
- `show_categories`: Show post categories

## Troubleshooting

### Sections Not Loading

1. Ensure `_plugins/sections_generator.rb` exists
2. Restart Jekyll server (plugins load at startup)
3. Check `_sections/<name>/config.yml` files exist

See [USAGE.md](USAGE.md) for more troubleshooting tips.

## Documentation

- [USAGE.md](USAGE.md) - Detailed usage guide
- [Theme Repository](https://github.com/dudududukim/spectrum-eager) - Theme source code

## License

This theme is open source and available under the [MIT License](LICENSE).
