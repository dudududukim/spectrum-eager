# Spectrum-Eager Jekyll Theme

A minimal, section-based Jekyll theme for personal websites and blogs.

## Quick Setup

```bash
curl -fsSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh | bash
```

Then:
1. Edit `_config.yml` to customize your site
2. Run `bundle install && bundle exec jekyll serve`
3. Push to GitHub and enable GitHub Pages

For manual setup, see [USAGE.md](USAGE.md).

## Features

- Section-based architecture
- YAML-first configuration
- Remote theme support
- Responsive design
- SEO optimized

## Project Structure

```
your-site/
├── _config.yml
├── _plugins/          # Required plugins
├── _posts/            # Blog posts
├── _films/            # Photography
├── _musics/           # Music picks
├── _sections/         # Section configs
│   └── <name>/
│       ├── config.yml
│       └── page.md
├── index.md
├── films.md
└── musics.md
```

## Content Types

### Posts
```yaml
---
layout: post
title: "Post Title"
date: 2024-01-01
section: "tech-bites"
---
```

### Films
```yaml
---
title: "Film Title"
image: "/assets/images/films/example.png"
date: 2024-01-01
---
```

### Musics
```yaml
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
type: "tech-bites-preview"
enabled: true
```

2. Create `_sections/<name>/page.md`:
```markdown
---
layout: post-list
section: "section-name"
permalink: /section-name/
---
```

## Configuration

See [USAGE.md](USAGE.md) for detailed configuration options.

## Documentation

- [USAGE.md](USAGE.md) - Detailed usage guide
- [Theme Repository](https://github.com/dudududukim/spectrum-eager)

## License

MIT License
