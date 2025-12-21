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

For detailed setup and usage, see [USAGE.md](USAGE.md).

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

## Documentation

- [USAGE.md](USAGE.md) - Complete setup guide, content creation, and configuration
- [Theme Repository](https://github.com/dudududukim/spectrum-eager)

## License

MIT License
