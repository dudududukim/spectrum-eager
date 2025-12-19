# Spectrum-Eager Personal Site

This is my personal website built with the [Spectrum Jekyll Theme](https://github.com/dudududukim/spectrum-eager).

## About This Site

This site uses the Spectrum theme via Jekyll's remote theme feature. The theme files are automatically loaded from the `theme` branch of the spectrum-eager repository.

## Site Structure

This repository contains only my personal content and configuration:

- `_posts/` - Blog posts and articles
- `_films/` - Photography entries
- `_data/` - Site configuration (navigation, sections)
- `_sections/` - Section-specific configurations
- `assets/images/` - Personal images
- `_config.yml` - Site settings
- `index.md`, `*.md` - Page files

Theme files (`_layouts/`, `_includes/`, `_sass/`, etc.) are loaded from the remote theme and are not stored in this repository.

## Local Development

1. Install dependencies:
```bash
bundle install
```

2. Run Jekyll locally:
```bash
bundle exec jekyll serve
```

3. Visit `http://localhost:4000` in your browser

## Adding Content

### Blog Posts
Create Markdown files in `_posts/` with front matter:
```yaml
---
title: "Post Title"
date: 2025-01-01
section: "tech-bites"
categories: ["Category"]
---
```

### Photography
Create Markdown files in `_films/` for photography entries.

### Sections
- Edit `_data/sections.yml` to define sections
- Create `_sections/<name>/config.yml` for section-specific settings
- Posts are filtered by the `section` field in front matter

## Configuration

- `_config.yml` - Site-wide settings (url, colors, etc.)
- `_data/navigation.yml` - Navigation menu
- `_data/sections.yml` - Section definitions
- `_sections/*/config.yml` - Section-specific settings

## Theme

This site uses the Spectrum Jekyll Theme via remote theme:
- Theme repository: [dudududukim/spectrum-eager](https://github.com/dudududukim/spectrum-eager)
- Theme branch: `theme`

For theme documentation, see the [theme repository](https://github.com/dudududukim/spectrum-eager).
