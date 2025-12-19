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
if [ ! -f "_config.yml" ]; then
    echo "❌ Error: _config.yml not found. Please run this script in your Jekyll site root directory."
    exit 1
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
echo "   1. Update _config.yml with your site settings"
echo "   2. Run: bundle install"
echo "   3. Run: bundle exec jekyll serve"
echo "   4. Visit: http://localhost:4000"
echo ""
echo "📚 For more information, see USAGE.md"

