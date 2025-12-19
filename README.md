# Spectrum-Eager Jekyll Theme

A minimal, section-based Jekyll theme for personal websites and blogs.

## Using as Remote Theme

The easiest way to use this theme is as a remote theme in your own Jekyll site. This allows you to use the theme without forking the repository and automatically receive updates.

### Quick Setup (Recommended)

#### Step 1: Clone Your Repository

If you're setting up a new GitHub Pages site:

```bash
git clone https://github.com/yourusername/yourusername.github.io.git
cd yourusername.github.io
```

Or if you already have a repository:

```bash
cd yourusername.github.io
```

#### Step 2: Run the Automated Setup Script

The setup script will automatically configure everything for you:

```bash
curl -fsSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh | bash
```

**What the script does:**
- ✅ Automatically detects your GitHub repository information
- ✅ Creates `_config.yml` with correct URL settings
- ✅ Creates `index.md` for your homepage
- ✅ Sets up `Gemfile` with required dependencies
- ✅ Downloads the required plugin (`_plugins/sections_generator.rb`)
- ✅ Creates an example section (`_sections/tech-bites/`)
- ✅ Sets up GitHub Actions workflow for deployment

#### Step 3: Customize Your Configuration

Edit `_config.yml` and update:

- **Site Identity**: `site.title`, `site.description`, `site.author`, `site.email`
- **Personal Information**: `personal.name`, `personal.tagline`, `personal.bio`, `personal.location`, `personal.photo`
- **Social Media**: Enable and configure links in `social.platforms`
- **Theme Color**: Change `site_theme.colors.primary` to your preferred color
- **Content**: Customize `content.pages.about` with your welcome message

#### Step 4: Install Dependencies

```bash
bundle install
```

#### Step 5: Test Locally

```bash
bundle exec jekyll serve
```

Visit `http://localhost:4000` to see your site!

#### Step 6: Deploy to GitHub Pages

1. Commit and push your changes:
   ```bash
   git add .
   git commit -m "Add Spectrum-Eager theme"
   git push origin main
   ```

2. Enable GitHub Pages:
   - Go to your repository on GitHub
   - Navigate to **Settings > Pages**
   - Under **Source**, select **GitHub Actions**
   - Your site will build and deploy automatically!

### Manual Setup

If you prefer to set up manually or want more control, see [USAGE.md](USAGE.md) for detailed step-by-step instructions.

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
