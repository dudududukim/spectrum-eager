#!/bin/bash

# Spectrum-Eager Remote Theme Setup Script
# This script sets up your Jekyll site to use the remote theme
# by copying necessary files from the remote theme repository

set -e

THEME_REPO="dudududukim/spectrum-eager"
THEME_BRANCH="theme"
THEME_VERSION="${1:-v2.0.7}"

echo "🚀 Setting up Spectrum-Eager Remote Theme..."
echo "📦 Theme: ${THEME_REPO}@${THEME_VERSION}"
echo ""

# Check if we're in a Jekyll site directory
# If _config.yml doesn't exist, create a minimal one
if [ ! -f "_config.yml" ]; then
    echo "⚠️  _config.yml not found. Creating a minimal configuration file..."
    echo ""
    
    # Try to detect GitHub Pages repository
    GITHUB_REPO=""
    if [ -d ".git" ]; then
        # Try to get remote URL
        REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
        if [[ "$REMOTE_URL" == *"github.com"* ]]; then
            # Extract repo name from URL
            if [[ "$REMOTE_URL" == *".git" ]]; then
                GITHUB_REPO=$(basename "$REMOTE_URL" .git)
            else
                GITHUB_REPO=$(basename "$REMOTE_URL")
            fi
        fi
    fi
    
    # Create minimal _config.yml
    cat > _config.yml << EOF
# ===========================================
# SPECTRUM JEKYLL THEME - MAIN CONFIGURATION
# ===========================================

# Remote Theme Configuration
remote_theme: ${THEME_REPO}@${THEME_VERSION}

# Jekyll Core Settings
markdown: kramdown
highlighter: rouge
permalink: pretty
timezone: UTC

# Site URL (update with your GitHub Pages URL)
url: "https://${GITHUB_REPO:-your-username.github.io}"
baseurl: ""

# Site Identity
site:
  title: "Your Site Title"
  description: "Your site description"
  author: "Your Name"
  email: "your-email@example.com"

# Collections (required for sections to work)
collections:
  posts:
    output: true
    permalink: /posts/:name/
  sections:
    output: true
    files: true

# Default Front Matter (required for sections)
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
  - scope:
      path: "_sections"
      type: "sections"
    values:
      layout: "post-list"

# Plugins
plugins:
  - jekyll-remote-theme
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag

# Build Settings
exclude:
  - Gemfile
  - Gemfile.lock
  - node_modules
  - vendor/
  - README.md
  - .gitignore
  - _sections/**/config.yml
EOF
    
    echo "✅ Created minimal _config.yml"
    echo "   Please update it with your site settings (url, title, author, etc.)"
    echo ""
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p _plugins
mkdir -p _sections/tech-bites
mkdir -p _sections/3d-printing
echo "✅ Directories created"

# Download plugin from GitHub
echo ""
echo "📥 Downloading required plugin..."
PLUGIN_URL="https://raw.githubusercontent.com/${THEME_REPO}/${THEME_VERSION}/_plugins/sections_generator.rb"
curl -s -o _plugins/sections_generator.rb "${PLUGIN_URL}" || {
    echo "⚠️  Warning: Could not download plugin from GitHub."
    echo "   Please manually copy _plugins/sections_generator.rb from the theme repository."
}

if [ -f "_plugins/sections_generator.rb" ]; then
    echo "✅ Plugin downloaded successfully"
else
    echo "❌ Error: Plugin file not found. Please check your internet connection or theme version."
    exit 1
fi

# Create example section configs if they don't exist
if [ ! -f "_sections/tech-bites/config.yml" ]; then
    echo ""
    echo "📝 Creating example section configs..."
    cat > _sections/tech-bites/config.yml << 'EOF'
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
EOF

    cat > _sections/tech-bites/page.md << 'EOF'
---
layout: post-list
title: "Tech Bites"
description: "Daily tech insights and discoveries"
section: "tech-bites"
permalink: /tech-bites/
---

This is an example Tech Bites listing page. Users should customize this page with their own content.
EOF

    cat > _sections/3d-printing/config.yml << 'EOF'
title: "3D Printing"
key: "3d-printing"
description: "Notes and experiments on printers, slicers, and materials"
button_text: "Browse 3D Printing"
button_url: "/3d-printing/"
order: 20
type: "tech-bites-preview"
enabled: true
main_page_count: 3
pagination: 10
show_dates: true
show_categories: true
EOF

    cat > _sections/3d-printing/page.md << 'EOF'
---
layout: post-list
title: "3D Printing"
description: "Notes and experiments on printers, slicers, and materials"
section: "3d-printing"
permalink: /3d-printing/
---

This is an example 3D Printing listing page. Users should customize this page with their own content.
EOF

    echo "✅ Example section configs created"
fi

# Check _config.yml for remote_theme setting
if ! grep -q "remote_theme:" _config.yml; then
    echo ""
    echo "⚠️  Warning: remote_theme not found in _config.yml"
    echo "   Please add the following to your _config.yml:"
    echo "   remote_theme: ${THEME_REPO}@${THEME_VERSION}"
fi

# Check Gemfile for jekyll-remote-theme
if [ -f "Gemfile" ]; then
    if ! grep -q "jekyll-remote-theme" Gemfile; then
        echo ""
        echo "⚠️  Warning: jekyll-remote-theme not found in Gemfile"
        echo "   Please add the following to your Gemfile:"
        echo "   gem \"jekyll-remote-theme\", \"0.4.3\""
    fi
else
    echo ""
    echo "⚠️  Warning: Gemfile not found"
    echo "   Please create a Gemfile with jekyll-remote-theme"
fi

echo ""
echo "✨ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Update _config.yml with your site settings:"
echo "      - Update url and baseurl (if needed)"
echo "      - Update site title, description, and author"
echo "      - Add personal information and social links"
echo ""
echo "   2. Create or update Gemfile:"
echo "      Add the following to your Gemfile:"
echo "      source \"https://rubygems.org\""
echo "      gem \"jekyll\", \"~> 4.3.0\""
echo "      gem \"openssl\", \"~> 3.3.1\""
echo "      group :jekyll_plugins do"
echo "        gem \"jekyll-remote-theme\", \"0.4.3\""
echo "        gem \"jekyll-feed\", \"~> 0.12\""
echo "        gem \"jekyll-sitemap\""
echo "        gem \"jekyll-seo-tag\""
echo "      end"
echo ""
echo "   3. Install dependencies:"
echo "      bundle install"
echo ""
echo "   4. Run Jekyll server:"
echo "      bundle exec jekyll serve"
echo ""
echo "   5. Visit: http://localhost:4000"
echo ""
echo "📚 For more information, see:"
echo "   https://github.com/${THEME_REPO}/blob/${THEME_VERSION}/USAGE.md"

