# Using Spectrum-Eager as a Remote Theme

## Quick Setup

```bash
curl -fsSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh | bash
```

The script will:
- Create `_config.yml` with correct URL settings
- Create `index.md`, `films.md`, `musics.md`
- Set up `Gemfile` with required dependencies
- Download required plugins
- Set up GitHub Actions workflow

## Manual Setup

### 1. Create `_config.yml`

```yaml
remote_theme: dudududukim/spectrum-eager@theme

url: "https://yourusername.github.io"
baseurl: ""  # Empty for user.github.io, "/repo-name" for project pages

site:
  title: "Your Site Title"
  description: "Your site description"
  author: "Your Name"

site_theme:
  colors:
    primary: "#3498db"

personal:
  name: "Your Name"
  tagline: "Your tagline"
  bio: "Your bio"
  photo: "/assets/images/me/me.jpeg"

social:
  enabled: true
  platforms:
    github:
      enabled: true
      url: "https://github.com/yourusername"

plugins:
  - jekyll-remote-theme
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag

collections:
  posts:
    output: true
    permalink: /posts/:name/
  films:
    output: true
    permalink: /films/:name/
  musics:
    output: true
    permalink: /musics/:name/
  sections:
    output: false
    files: true

section_settings:
  gallery_track:
    card_duration: 10
    direction: left
  music_gallery:
    card_duration: 20
    direction: right
    link_text: "🎶 Your pick"
```

### 2. Create `index.md`

```markdown
---
layout: about
title: "About"
---
```

### 3. Create `Gemfile`

```ruby
source "https://rubygems.org"

gem "jekyll", "~> 4.3.0"

group :jekyll_plugins do
  gem "jekyll-remote-theme", "0.4.3"
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
end
```

### 4. Download Plugins

```bash
mkdir -p _plugins
curl -fsSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/_plugins/sections_generator.rb -o _plugins/sections_generator.rb
curl -fsSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/_plugins/image_resizer.rb -o _plugins/image_resizer.rb
```

### 5. Install and Test

```bash
bundle install
bundle exec jekyll serve
```

## Creating Content

### Posts

Create files in `_posts/`:

```markdown
---
layout: post
title: "Post Title"
date: 2024-01-01
section: "tech-bites"
---
```

### Films

Create files in `_films/`:

```markdown
---
title: "Film Title"
image: "/assets/images/films/example.png"
date: 2024-01-01
---
```

### Musics

Create files in `_musics/`:

```markdown
---
title: "Music Title"
artist: "Artist Name"
date: 2024-01-01
---
```

### Sections

1. Create `_sections/<name>/config.yml`:

```yaml
title: "Section Title"
key: "section-name"
description: "Description"
button_text: "View All"
button_url: "/section-name/"
order: 10
type: "tech-bites-preview"
enabled: true
```

2. Create `_sections/<name>/page.md`:

```markdown
---
layout: post-list
title: "Section Title"
section: "section-name"
permalink: /section-name/
---
```

## Configuration

### Gallery Animation

Edit `section_settings` in `_config.yml`:

```yaml
section_settings:
  gallery_track:
    card_duration: 10  # Seconds per card
    direction: left    # 'left' or 'right'
  music_gallery:
    card_duration: 20
    direction: right
    link_text: "🎶 Your pick"
```

## Troubleshooting

- **Plugin errors**: Ensure `_plugins/` files are present
- **Build errors**: Run `bundle install` and check `remote_theme` in `_config.yml`
- **Sections not appearing**: Verify `_sections/<name>/config.yml` exists and posts have correct `section` field
