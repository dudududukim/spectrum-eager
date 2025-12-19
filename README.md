# Spectrum-Eager Personal Site

This is my personal website built with the [Spectrum Jekyll Theme](https://github.com/dudududukim/spectrum-eager).

## About This Site

This site uses the Spectrum theme via Jekyll's remote theme feature. The theme files are automatically loaded from the `theme` branch of the spectrum-eager repository.

## Site Structure

This repository contains only my personal content and configuration:

- `_posts/` - Blog posts and articles
- `_films/` - Photography entries
- `_data/` - Site configuration (navigation, sections)
- `_sections/` - Section-specific configurations and page files
  - `_sections/<name>/config.yml` - Section configuration
  - `_sections/<name>/page.md` - Section listing page (optional)
- `assets/images/` - Personal images
- `_config.yml` - Site settings
- `index.md`, `films.md` - Root page files

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
- Create `_sections/<name>/config.yml` for each section (automatically loaded)
- Example: `_sections/tech-bites/config.yml`
- Posts are filtered by the `section` field in front matter
- **Note**: `_data/sections.yml` is no longer needed - sections are auto-discovered from `_sections/` folder

## Configuration

- `_config.yml` - Site-wide settings (url, colors, etc.)
- `_sections/<name>/config.yml` - Section-specific settings (auto-loaded from `_sections/` folder)

## Theme

This site uses the Spectrum Jekyll Theme via remote theme:
- Theme repository: [dudududukim/spectrum-eager](https://github.com/dudududukim/spectrum-eager)
- Theme branch: `theme`

For theme documentation, see the [theme repository](https://github.com/dudududukim/spectrum-eager).
