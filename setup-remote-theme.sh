#!/bin/bash

# ===========================================
# Spectrum-Eager Jekyll Theme Setup Script
# ===========================================
# This script automates the setup of the Spectrum-Eager theme
# for use as a remote theme in your Jekyll site.
#
# Usage:
#   ./setup-remote-theme.sh
#   curl -fsSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh | bash -s -- --no-serve
#
# Options:
#   --no-serve, --ci    Skip running Jekyll server (useful for CI/CD)
#   --help, -h          Show this help message

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Theme repository information
THEME_REPO="dudududukim/spectrum-eager"
THEME_BRANCH="theme"
THEME_VERSION="v3.0.0"
THEME_BASE_URL="https://raw.githubusercontent.com/${THEME_REPO}/${THEME_BRANCH}"

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_action() {
    echo -e "${BLUE}→${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not a git repository. Please run this script in your Jekyll site directory."
        exit 1
    fi
    print_success "Git repository detected"
}

# Extract GitHub repository information
extract_github_info() {
    local remote_url=$(git remote get-url origin 2>/dev/null || echo "")
    
    if [ -z "$remote_url" ]; then
        print_warning "No 'origin' remote found. Using default values."
        GITHUB_USER="yourusername"
        GITHUB_REPO="yourusername.github.io"
        SITE_URL="https://yourusername.github.io"
        BASEURL=""
        return
    fi
    
    # Extract username and repo from various URL formats
    if [[ $remote_url =~ github\.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
        GITHUB_USER="${BASH_REMATCH[1]}"
        GITHUB_REPO="${BASH_REMATCH[2]%.git}"
        
        # Determine if it's a user.github.io repo or project page
        if [[ $GITHUB_REPO =~ ^.*\.github\.io$ ]]; then
            SITE_URL="https://${GITHUB_USER}.github.io"
            BASEURL=""
        else
            SITE_URL="https://${GITHUB_USER}.github.io"
            BASEURL="/${GITHUB_REPO}"
        fi
        
        print_success "Detected GitHub repository: ${GITHUB_USER}/${GITHUB_REPO}"
        print_info "Site URL: ${SITE_URL}"
        print_info "Base URL: ${BASEURL:-/}"
    else
        print_warning "Could not parse GitHub URL. Using default values."
        GITHUB_USER="yourusername"
        GITHUB_REPO="yourusername.github.io"
        SITE_URL="https://yourusername.github.io"
        BASEURL=""
    fi
}

# Download file from theme repository
download_file() {
    local file_path=$1
    local output_path=$2
    local url="${THEME_BASE_URL}/${file_path}"
    
    if command_exists curl; then
        curl -fsSL "$url" -o "$output_path" || {
            print_error "Failed to download ${file_path}"
            return 1
        }
    elif command_exists wget; then
        wget -q "$url" -O "$output_path" || {
            print_error "Failed to download ${file_path}"
            return 1
        }
    else
        print_error "Neither curl nor wget is available. Please install one of them."
        exit 1
    fi
}

# Check if YAML key exists in file
check_yaml_key() {
    local file="$1"
    local key="$2"
    
    if [ ! -f "$file" ]; then
        return 1
    fi
    
    # Simple check: look for the key pattern (key: or "key":)
    if grep -qE "^[[:space:]]*${key}[[:space:]]*:" "$file" 2>/dev/null; then
        return 0
    fi
    
    # Also check for nested keys (key: with indentation)
    if grep -qE "^[[:space:]]+${key}[[:space:]]*:" "$file" 2>/dev/null; then
        return 0
    fi
    
    return 1
}

# Create _config.yml from template
create_config_yml() {
    local template_url="${THEME_BASE_URL}/_config.yml.template"
    local config_file="_config.yml"
    
    if [ -f "$config_file" ]; then
        local missing_keys=()
        ! check_yaml_key "$config_file" "image_resize" && missing_keys+=("image_resize")
        ! check_yaml_key "$config_file" "remote_theme" && missing_keys+=("remote_theme")
        
        if [ ${#missing_keys[@]} -gt 0 ]; then
            print_warning "${config_file} exists, missing keys: ${missing_keys[*]}"
        else
            print_action "${config_file} exists, skipping"
        fi
        return
    fi
    
    if command_exists curl; then
        curl -fsSL "$template_url" | \
            sed "s|https://CHANGE-THIS.github.io|${SITE_URL}|g" | \
            sed "s|baseurl: \"\"|baseurl: \"${BASEURL}\"|g" > "$config_file"
    elif command_exists wget; then
        wget -q -O- "$template_url" | \
            sed "s|https://CHANGE-THIS.github.io|${SITE_URL}|g" | \
            sed "s|baseurl: \"\"|baseurl: \"${BASEURL}\"|g" > "$config_file"
    fi
    
    print_success "Created ${config_file}"
}

# Create index.md from template
create_index_md() {
    local index_file="index.md"
    
    if [ -f "$index_file" ]; then
        print_action "${index_file} exists, skipping"
        return
    fi
    
    download_file "index.md.template" "$index_file"
    print_success "Created ${index_file}"
}

# Create films.md from template
create_films_md() {
    local films_file="films.md"
    
    if [ -f "$films_file" ]; then
        print_action "${films_file} exists, skipping"
        return
    fi
    
    download_file "films.md.template" "$films_file"
    print_success "Created ${films_file}"
}

# Create musics.md from template
create_musics_md() {
    local musics_file="musics.md"
    
    if [ -f "$musics_file" ]; then
        print_action "${musics_file} exists, skipping"
        return
    fi
    
    download_file "musics.md.template" "$musics_file"
    print_success "Created ${musics_file}"
}

# Create/update Gemfile
create_gemfile() {
    local gemfile="Gemfile"
    
    if [ -f "$gemfile" ]; then
        local missing_gems=()
        ! grep -q "jekyll-remote-theme" "$gemfile" && missing_gems+=("jekyll-remote-theme")
        ! grep -q "image_processing" "$gemfile" && missing_gems+=("image_processing")
        
        if [ ${#missing_gems[@]} -gt 0 ]; then
            print_warning "${gemfile} exists, missing gems: ${missing_gems[*]}"
            # Add missing gems
            for gem in "${missing_gems[@]}"; do
                if [ "$gem" = "jekyll-remote-theme" ]; then
                    if ! grep -q "group :jekyll_plugins" "$gemfile"; then
                        echo "" >> "$gemfile"
                        echo "group :jekyll_plugins do" >> "$gemfile"
                        echo "  gem \"jekyll-remote-theme\", \"0.4.3\"" >> "$gemfile"
                        echo "end" >> "$gemfile"
                    else
                        if ! grep -q "jekyll-remote-theme" "$gemfile"; then
                            sed -i.bak '/group :jekyll_plugins do/a\
  gem "jekyll-remote-theme", "0.4.3"
' "$gemfile" 2>/dev/null || \
                            sed -i '' '/group :jekyll_plugins do/a\
  gem "jekyll-remote-theme", "0.4.3"
' "$gemfile"
                        fi
                    fi
                elif [ "$gem" = "image_processing" ]; then
                    if ! grep -q "image_processing" "$gemfile"; then
                        echo "" >> "$gemfile"
                        echo "# Image processing for automatic image resizing" >> "$gemfile"
                        echo "gem \"image_processing\", \"~> 1.12\"" >> "$gemfile"
                    fi
                fi
            done
            print_success "Added missing gems to ${gemfile}"
        else
            print_action "${gemfile} exists, skipping"
        fi
        return
    fi
    
    download_file "Gemfile.template" "$gemfile"
    print_success "Created ${gemfile}"
}

# Download plugin
download_plugin() {
    mkdir -p "_plugins"
    
    download_file "_plugins/sections_generator.rb" "_plugins/sections_generator.rb"
    print_success "Updated sections_generator.rb"
    
    download_file "_plugins/image_resizer.rb" "_plugins/image_resizer.rb"
    print_success "Updated image_resizer.rb"
}

# Create GitHub Actions workflow
create_workflow() {
    local workflow_file=".github/workflows/jekyll.yml"
    
    if [ -f "$workflow_file" ]; then
        print_action "${workflow_file} exists, skipping"
        return
    fi
    
    mkdir -p ".github/workflows"
    download_file ".github/workflows/jekyll.yml.template" "$workflow_file"
    print_success "Created ${workflow_file}"
}

# Copy files from source to destination if they don't exist
copy_if_not_exists() {
    local src_dir="$1"
    local dst_dir="$2"
    local pattern="$3"
    local label="$4"
    
    if [ ! -d "$src_dir" ] || [ -z "$(ls -A "$src_dir" 2>/dev/null)" ]; then
        return
    fi
    
    mkdir -p "$dst_dir"
    for file in "$src_dir"/$pattern; do
        [ -f "$file" ] || continue
        local filename=$(basename "$file")
        if [ ! -f "$dst_dir/$filename" ]; then
            cp "$file" "$dst_dir/$filename"
            print_success "Copied ${filename} to ${label}/"
        else
            print_action "${label}/${filename} exists, skipping"
        fi
    done
}

# Copy example files from examples/ folder
copy_examples() {
    local examples_dir="examples"
    
    # Create examples directory if it doesn't exist
    if [ ! -d "$examples_dir" ]; then
        mkdir -p "$examples_dir"
    fi
    
    # Download example files from remote
    print_action "Downloading example files from remote..."
    local files=(
        "_posts/2025-12-19-example-post.md"
        "_films/example-film-1.md"
        "_films/example-film-2.md"
        "_films/example-film-3.md"
        "_musics/example-music-1.md"
        "_musics/example-music-2.md"
        "_musics/example-music-3.md"
        "assets/images/films/example-1.png"
        "assets/images/films/example-2.png"
        "assets/images/films/example-3.png"
        "_sections/tech-bites/config.yml"
        "_sections/tech-bites/page.md"
        "_sections/hobbies/config.yml"
        "_sections/hobbies/page.md"
    )
    
    for file in "${files[@]}"; do
        local target_file="${examples_dir}/${file}"
        
        # Download if file doesn't exist or --refresh-examples is set
        if [ ! -f "$target_file" ] || [ "$REFRESH_EXAMPLES" = true ]; then
            mkdir -p "${examples_dir}/$(dirname "$file")"
            download_file "examples/${file}" "$target_file" 2>/dev/null || {
                print_warning "Failed to download examples/${file}, skipping"
            }
        fi
    done
    
    # Copy all files from examples directory recursively
    print_action "Copying example files from ${examples_dir}/..."
    
    # Copy _posts
    copy_if_not_exists "${examples_dir}/_posts" "_posts" "*.md" "_posts"
    
    # Copy _films
    copy_if_not_exists "${examples_dir}/_films" "_films" "*.md" "_films"
    
    # Copy _musics
    copy_if_not_exists "${examples_dir}/_musics" "_musics" "*.md" "_musics"
    
    # Copy assets/images recursively
    if [ -d "${examples_dir}/assets/images" ]; then
        mkdir -p "assets/images"
        # Use find to copy all files recursively
        find "${examples_dir}/assets/images" -type f | while read -r file; do
            local rel_path="${file#${examples_dir}/assets/images/}"
            local target_file="assets/images/${rel_path}"
            local target_dir=$(dirname "$target_file")
            
            mkdir -p "$target_dir"
            if [ ! -f "$target_file" ]; then
                cp "$file" "$target_file"
                print_success "Copied ${rel_path} to assets/images/"
            else
                print_action "assets/images/${rel_path} exists, skipping"
            fi
        done
    fi
    
    # Copy example sections
    if [ -d "${examples_dir}/_sections" ] && [ "$(ls -A ${examples_dir}/_sections 2>/dev/null)" ]; then
        for section_dir in "${examples_dir}/_sections"/*; do
            [ -d "$section_dir" ] || continue
            local section_name=$(basename "$section_dir")
            local target_dir="_sections/${section_name}"
            mkdir -p "$target_dir"
            
            for file in "config.yml" "page.md"; do
                if [ -f "${section_dir}/${file}" ] && [ ! -f "${target_dir}/${file}" ]; then
                    cp "${section_dir}/${file}" "${target_dir}/${file}"
                    print_success "Copied ${section_name}/${file} to _sections/"
                elif [ -f "${target_dir}/${file}" ]; then
                    print_action "_sections/${section_name}/${file} exists, skipping"
                fi
            done
        done
    fi
}

# Check Ruby/Bundler and run bundle install
run_bundle_install() {
    if ! command_exists ruby; then
        print_warning "Ruby not found. Skipping bundle install."
        return 1
    fi
    
    if ! command_exists bundle; then
        print_action "Installing bundler..."
        gem install bundler >/dev/null 2>&1 || {
            print_warning "Failed to install bundler. Run 'gem install bundler' manually."
            return 1
        }
    fi
    
    print_action "Running bundle install..."
    if bundle install >/dev/null 2>&1; then
        print_success "Dependencies installed"
        return 0
    else
        print_warning "bundle install failed. Run 'bundle install' manually."
        return 1
    fi
}

# Run Jekyll serve
run_jekyll_serve() {
    print_action "Starting Jekyll server..."
    print_info "Visit http://localhost:4000"
    print_info "Press Ctrl+C to stop"
    echo ""
    bundle exec jekyll serve
}

# Parse command line arguments
NO_SERVE=false
REFRESH_EXAMPLES=false

show_help() {
    echo "Spectrum-Eager Jekyll Theme Setup Script"
    echo ""
    echo "Usage:"
    echo "  ./setup-remote-theme.sh"
    echo "  curl -fsSL <URL> | bash"
    echo "  curl -fsSL <URL> | bash -s -- --no-serve"
    echo "  curl -fsSL <URL> | bash -s -- --no-serve --refresh-examples"
    echo ""
    echo "Options:"
    echo "  --no-serve, --ci        Skip running Jekyll server (useful for CI/CD)"
    echo "  --refresh-examples      Force re-download all example files (overwrite existing)"
    echo "  --help, -h              Show this help message"
    echo ""
}

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --no-serve|--ci)
            NO_SERVE=true
            ;;
        --refresh-examples)
            REFRESH_EXAMPLES=true
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            print_warning "Unknown option: $arg"
            print_info "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Main setup function
main() {
    echo ""
    echo "=========================================="
    echo "  Spectrum-Eager Theme Setup"
    echo "=========================================="
    echo ""
    
    check_git_repo
    extract_github_info
    echo ""
    
    # Create/update files
    create_config_yml
    create_index_md
    create_films_md
    create_musics_md
    create_gemfile
    download_plugin
    create_workflow
    copy_examples
    
    echo ""
    echo "=========================================="
    print_success "Files setup completed!"
    echo "=========================================="
    echo ""
    
    # Bundle install & Serve
    if run_bundle_install; then
        echo ""
        if [ "$NO_SERVE" = true ]; then
            print_success "Setup completed in no-serve mode"
            echo ""
            print_info "Next steps:"
            echo "  1. bundle exec jekyll build    # Build the site"
            echo "  2. bundle exec jekyll serve    # Start local server"
            echo ""
        else
            run_jekyll_serve
        fi
    else
        echo ""
        print_info "Next steps:"
        echo "  1. bundle install"
        echo "  2. bundle exec jekyll serve"
        echo ""
    fi
}

# Run main function
main
