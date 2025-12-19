# Remote Theme Usage Guide

## Current Structure

- **theme branch**: Theme code (layouts, styles, JavaScript, etc.)
- **main branch**: User site (content, configuration files)

## Usage

### 1. Push Theme Branch (First Time Only)

First, you need to push the theme branch to GitHub:

```bash
# Switch to theme branch
git checkout theme

# Commit changes
git add .
git commit -m "feat: prepare theme branch for remote theme"

# Push to GitHub
git push origin theme
```

### 2. Install Dependencies on Main Branch

```bash
# Switch to main branch
git checkout main

# Install dependencies
bundle install
```

### 3. Test Locally

```bash
# Run Jekyll server
bundle exec jekyll serve

# Check in browser
# http://localhost:4000/spectrum-eager/
```

### 4. Deploy to GitHub Pages

#### Method 1: Use GitHub Actions (Recommended)

1. Check if `.github/workflows/jekyll.yml` file exists
2. In GitHub repository Settings > Pages, set Source to "GitHub Actions"
3. Push to main branch and it will build automatically

```bash
git add .
git commit -m "feat: configure remote theme"
git push origin main
```

#### Method 2: Build Locally and Push

```bash
# Build
bundle exec jekyll build

# Push _site folder to gh-pages branch
```

## File Management

### Files Managed by User (main branch)

**Content:**
- `_posts/` - Blog posts
- `_films/` - Photo gallery
- `index.md`, `films.md` - Root page files
- `_sections/<name>/page.md` - Section listing pages (auto-generated from `_sections/` folder)

**Configuration:**
- `_config.yml` - Site settings
- `_sections/<name>/config.yml` - Section-specific settings (auto-loaded)
  - Example: `_sections/tech-bites/config.yml`
  - `_data/sections.yml` is no longer needed

**Images:**
- `assets/images/` - User images

### Theme Files (theme branch, auto-loaded)

The following files are automatically loaded via remote-theme, so they don't need to be in the main branch:
- `_layouts/`
- `_includes/`
- `_sass/`
- `assets/css/`
- `assets/js/`

## Theme Updates

To update the theme:

1. Commit and push changes on theme branch
2. Run `bundle update jekyll-remote-theme` on main branch (if needed)
3. Site will automatically use the new theme

## Troubleshooting

### Theme Not Loading

1. Check if theme branch is pushed to GitHub
2. Check `remote_theme` setting in `_config.yml`:
   ```yaml
   remote_theme: dudududukim/spectrum-eager@theme
   ```
3. Check if `jekyll-remote-theme` is in `Gemfile`
4. Run `bundle install`

### Local Build Errors

```bash
# Clear cache and retry
rm -rf .jekyll-cache _site
bundle exec jekyll serve
```

## Next Steps

1. ✅ Push theme branch
2. ✅ bundle install
3. ✅ Test locally
4. ✅ Deploy to GitHub Pages
