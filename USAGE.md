# Using Spectrum-Eager as a Remote Theme

This guide explains how to use the Spectrum-Eager Jekyll theme as a remote theme in your own Jekyll site.

## Quick Setup (Recommended)

The easiest way to set up the theme is using our automated setup script:

### Step 1: Clone Your Repository

If you're setting up a new site:

```bash
git clone https://github.com/yourusername/yourusername.github.io.git
cd yourusername.github.io
```

Or if you already have a repository:

```bash
cd yourusername.github.io
```

### Step 2: Run the Setup Script

```bash
curl -fsSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh | bash
```

This script will:
- Automatically detect your GitHub repository information
- Create `_config.yml` with the correct URL settings
- Create `index.md` for your homepage
- Set up `Gemfile` with required dependencies
- Download the required plugin (`_plugins/sections_generator.rb`)
- Create an example section (`_sections/tech-bites/`)
- Set up GitHub Actions workflow for deployment

### Step 3: Customize Configuration

Edit `_config.yml` and update the following sections:

- **Site Identity**: Update `site.title`, `site.description`, `site.author`, `site.email`
- **Personal Information**: Update `personal.name`, `personal.tagline`, `personal.bio`, `personal.location`, `personal.photo`
- **Social Media**: Enable and configure your social media links in the `social.platforms` section
- **Theme Color**: Change `site_theme.colors.primary` to your preferred color
- **Content**: Customize `content.pages.about` with your welcome message and description

### Step 4: Install Dependencies

```bash
bundle install
```

### Step 5: Test Locally

```bash
bundle exec jekyll serve
```

Visit `http://localhost:4000` to see your site.

### Step 6: Deploy to GitHub Pages

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
   - The site will build and deploy automatically

## Manual Setup

If you prefer to set up the theme manually, follow these steps:

### Step 1: Create `_config.yml`

Create a `_config.yml` file in your repository root with the following minimum configuration:

```yaml
# Remote Theme Configuration
remote_theme: dudududukim/spectrum-eager@v3.0.0

# Site URL (adjust for your repository)
url: "https://yourusername.github.io"
baseurl: ""  # Empty for user.github.io, "/repo-name" for project pages

# Site Identity
site:
  title: "Your Site Title"
  description: "Your site description"
  author: "Your Name"
  email: "your.email@example.com"

# Theme Configuration
site_theme:
  colors:
    primary: "#3498db"  # Your primary theme color

# Personal Information
personal:
  name: "Your Name"
  tagline: "Your tagline"
  bio: "Your bio"
  location: "Your Location"
  photo: "/assets/images/me/me.jpeg"

# Social Media Links
social:
  enabled: true
  platforms:
    email:
      enabled: true
      url: "mailto:your.email@example.com"
    github:
      enabled: true
      url: "https://github.com/yourusername"
    # Add other platforms as needed

# Plugins (required)
plugins:
  - jekyll-remote-theme
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag

# Collections
collections:
  posts:
    output: true
    permalink: /posts/:name/
  sections:
    output: false
    files: true

# Default Front Matter
defaults:
  - scope:
      path: ""
      type: "pages"
    values:
      layout: "default"
  - scope:
      path: ""
      type: "posts"
    values:
      layout: "post"
      show_sidebar: true
```

For a complete configuration template, see the [theme repository](https://github.com/dudududukim/spectrum-eager/blob/theme/_config.yml.template).

### Step 2: Create `index.md`

Create an `index.md` file in your repository root:

```markdown
---
layout: about
title: "About"
description: "Personal website"
---

Welcome to my site!

[Your content here]
```

### Step 3: Create `Gemfile`

Create a `Gemfile` with the following content:

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

### Step 4: Download the Plugin

Jekyll plugins must be local files. Download the required plugin:

```bash
mkdir -p _plugins
curl -fsSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/_plugins/sections_generator.rb -o _plugins/sections_generator.rb
```

### Step 5: Create Example Section (Optional)

To use sections, create a section directory:

```bash
mkdir -p _sections/tech-bites
```

Create `_sections/tech-bites/config.yml`:

```yaml
title: "Tech Bites"
key: "tech-bites"
description: "Daily tech insights and discoveries"
button_text: "View All Tech Bites"
button_url: "/tech-bites/"
order: 10
type: "tech-bites-preview"
enabled: true
main_page_count: 3
pagination: 10
show_dates: true
show_categories: true
```

Create `_sections/tech-bites/page.md`:

```markdown
---
layout: post-list
title: "Tech Bites"
description: "Daily tech insights and discoveries"
section: "tech-bites"
permalink: /tech-bites/
---

Your Tech Bites content here.
```

### Step 6: Install Dependencies and Test

```bash
bundle install
bundle exec jekyll serve
```

## Creating Content

### Creating Posts

Create markdown files in `_posts/` directory with the following format:

```markdown
---
layout: post
title: "Your Post Title"
date: 2024-01-01
section: "tech-bites"
categories: [category1, category2]
---

Your post content here...
```

The `section` field determines which section the post belongs to. Posts with `section: "tech-bites"` will appear in the Tech Bites section.

### Creating Sections

To create a new section:

1. Create a directory under `_sections/`:
   ```bash
   mkdir -p _sections/your-section-name
   ```

2. Create `_sections/your-section-name/config.yml`:
   ```yaml
   title: "Your Section Title"
   key: "your-section-name"
   description: "Section description"
   button_text: "View All"
   button_url: "/your-section-name/"
   order: 20
   type: "tech-bites-preview"
   enabled: true
   main_page_count: 3
   pagination: 10
   show_dates: true
   show_categories: true
   ```

3. Create `_sections/your-section-name/page.md`:
   ```markdown
   ---
   layout: post-list
   title: "Your Section Title"
   description: "Section description"
   section: "your-section-name"
   permalink: /your-section-name/
   ---
   
   Your section content here.
   ```

4. Create posts with `section: "your-section-name"` in their front matter.

## Customization

### Changing Theme Color

Edit `_config.yml` and change the `primary` color:

```yaml
site_theme:
  colors:
    primary: "#e74c3c"  # Change to your preferred color
```

All UI elements will automatically adapt to this color.

### Customizing Homepage

Edit `_config.yml` under `content.pages.about`:

```yaml
content:
  pages:
    about:
      welcome_message: "Welcome!"
      intro_text: "Your introduction"
      main_description: "Your main description"
      sections:
        - title: "Section Title"
          content: "Section content"
      closing_text: "Closing message"
```

### Adding Social Media Links

Edit `_config.yml` under `social.platforms`:

```yaml
social:
  platforms:
    github:
      enabled: true
      url: "https://github.com/yourusername"
    linkedin:
      enabled: true
      url: "https://www.linkedin.com/in/yourusername/"
    # Add more platforms as needed
```

## Troubleshooting

### Plugin Not Loading

Make sure `_plugins/sections_generator.rb` is in your repository. Jekyll plugins must be local files and cannot be loaded from remote themes.

### Build Errors

1. Make sure all required gems are installed: `bundle install`
2. Check that `remote_theme` is correctly set in `_config.yml`
3. Verify that `jekyll-remote-theme` is in your `Gemfile`

### Sections Not Appearing

1. Make sure `_sections/<name>/config.yml` exists
2. Verify that `_plugins/sections_generator.rb` is present
3. Check that posts have the correct `section` field in their front matter

### GitHub Pages Not Building

1. Make sure GitHub Actions is enabled in repository Settings > Pages
2. Check the Actions tab for build errors
3. Verify that `.github/workflows/jekyll.yml` exists

## Getting Help

- Check the [main README](https://github.com/dudududukim/spectrum-eager) for more information
- Open an issue on [GitHub](https://github.com/dudududukim/spectrum-eager/issues) if you encounter problems
- Review the [Jekyll documentation](https://jekyllrb.com/docs/) for general Jekyll questions

## License

This theme is released under the MIT License. See the [LICENSE](https://github.com/dudududukim/spectrum-eager/blob/main/LICENSE) file for details.
