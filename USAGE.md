# Remote Theme Usage Guide

## Quick Start

### Automated Setup (Recommended)

1. **Run the setup script** in your Jekyll site root directory:
   ```bash
   curl -sSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh | bash -s v2.0.7
   ```
   
   Or download and run manually:
   ```bash
   wget https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh
   chmod +x setup-remote-theme.sh
   ./setup-remote-theme.sh v2.0.7
   ```

   This script will automatically:
   - Download `_plugins/sections_generator.rb` (required for sections to work)
   - Create example `_sections` folder structure
   - Verify your `_config.yml` and `Gemfile` settings

2. **Configure your site**:
   - Update `_config.yml` with your site settings
   - Add `remote_theme: dudududukim/spectrum-eager@v2.0.7` to `_config.yml`
   - Add `jekyll-remote-theme` to your `Gemfile`

3. **Install and run**:
   ```bash
   bundle install
   bundle exec jekyll serve
   ```

### Manual Setup

If you prefer to set up manually, follow the steps below.

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

**Required Files (must be in your repository):**
- `_plugins/sections_generator.rb` - **REQUIRED**: Plugin to load section configs
  - Download from: `https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/_plugins/sections_generator.rb`
  - Or use the setup script to automatically download it

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

**Note**: `_plugins/` folder is NOT automatically loaded from remote theme. You must copy `_plugins/sections_generator.rb` to your local repository.

## Theme Updates

To update the theme:

1. Commit and push changes on theme branch
2. Run `bundle update jekyll-remote-theme` on main branch (if needed)
3. Site will automatically use the new theme

## Troubleshooting

### "_sections" Not Found / Sections Not Loading

If you see "No sections configured yet" or sections are not loading:

1. **Check if `_plugins/sections_generator.rb` exists**:
   ```bash
   ls _plugins/sections_generator.rb
   ```
   If it doesn't exist, download it:
   ```bash
   mkdir -p _plugins
   curl -o _plugins/sections_generator.rb https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/_plugins/sections_generator.rb
   ```

2. **Restart Jekyll server** (plugins are loaded at startup):
   ```bash
   # Stop the server (Ctrl+C) and restart
   bundle exec jekyll serve
   ```

3. **Verify `_sections` folder structure**:
   ```bash
   ls -la _sections/tech-bites/config.yml
   ```

### Theme Not Loading

1. Check if theme branch is pushed to GitHub
2. Check `remote_theme` setting in `_config.yml`:
   ```yaml
   remote_theme: dudududukim/spectrum-eager@v2.0.7
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
