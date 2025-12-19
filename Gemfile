source "https://rubygems.org"

# Jekyll version
gem "jekyll", "~> 4.3.0"

# Ruby 3.4.0+ compatibility - these gems are no longer included by default
gem "csv"
gem "base64"
gem "bigdecimal"
gem "logger"
gem "openssl", "~> 3.3.1"

# Jekyll plugins required for this theme
group :jekyll_plugins do
  gem "jekyll-remote-theme", "0.4.3"  # Required for using remote theme
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
end

# Image processing for automatic image resizing
# Note: Requires system library - install one of:
#   - libvips: brew install vips (macOS) or apt-get install libvips-dev (Linux)
#   - ImageMagick: brew install imagemagick (macOS) or apt-get install imagemagick (Linux)
gem "image_processing", "~> 1.12"

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]

# Development dependencies (optional)
group :development do
  gem "jekyll-admin"
  gem "jekyll-watch"
end

