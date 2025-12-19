#!/bin/bash

# ===========================================
# Spectrum-Eager Jekyll Theme Setup Script
# ===========================================
# This script automates the setup of the Spectrum-Eager theme
# for use as a remote theme in your Jekyll site.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh | bash
#   or
#   wget -O- https://raw.githubusercontent.com/dudududukim/spectrum-eager/theme/setup-remote-theme.sh | bash

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
    
    print_info "Downloading ${file_path}..."
    
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
    
    print_success "Downloaded ${file_path}"
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
        print_warning "${config_file} already exists. Checking for required settings..."
        
        # Check for important keys
        local missing_keys=()
        
        if ! check_yaml_key "$config_file" "image_resize"; then
            missing_keys+=("image_resize")
        fi
        
        if [ ${#missing_keys[@]} -gt 0 ]; then
            print_warning "Missing configuration keys in ${config_file}:"
            for key in "${missing_keys[@]}"; do
                echo "  - ${key}"
            done
            echo "  Consider adding these settings from the template."
        fi
        
        print_warning "Creating backup before updating..."
        cp "$config_file" "${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    print_info "Creating ${config_file}..."
    
    if command_exists curl; then
        curl -fsSL "$template_url" | \
            sed "s|https://CHANGE-THIS.github.io|${SITE_URL}|g" | \
            sed "s|baseurl: \"\"|baseurl: \"${BASEURL}\"|g" > "$config_file"
    elif command_exists wget; then
        wget -q -O- "$template_url" | \
            sed "s|https://CHANGE-THIS.github.io|${SITE_URL}|g" | \
            sed "s|baseurl: \"\"|baseurl: \"${BASEURL}\"|g" > "$config_file"
    fi
    
    print_success "Created ${config_file} with auto-detected URL settings"
}

# Create index.md from template
create_index_md() {
    local template_url="${THEME_BASE_URL}/index.md.template"
    local index_file="index.md"
    
    if [ -f "$index_file" ]; then
        print_warning "${index_file} already exists. Skipping..."
        return
    fi
    
    print_info "Creating ${index_file}..."
    download_file "index.md.template" "$index_file"
    print_success "Created ${index_file}"
}

# Create films.md from template
create_films_md() {
    local template_url="${THEME_BASE_URL}/films.md.template"
    local films_file="films.md"
    
    if [ -f "$films_file" ]; then
        print_warning "${films_file} already exists. Skipping..."
        return
    fi
    
    print_info "Creating ${films_file}..."
    download_file "films.md.template" "$films_file"
    print_success "Created ${films_file}"
}

# Create/update Gemfile
create_gemfile() {
    local template_url="${THEME_BASE_URL}/Gemfile.template"
    local gemfile="Gemfile"
    
    if [ -f "$gemfile" ]; then
        local missing_gems=()
        
        # Check for required gems
        if ! grep -q "jekyll-remote-theme" "$gemfile"; then
            missing_gems+=("jekyll-remote-theme")
        fi
        
        if ! grep -q "image_processing" "$gemfile"; then
            missing_gems+=("image_processing")
        fi
        
        if [ ${#missing_gems[@]} -gt 0 ]; then
            print_warning "${gemfile} exists but missing required gems:"
            for gem in "${missing_gems[@]}"; do
                echo "  - ${gem}"
            done
            print_info "Adding missing gems to ${gemfile}..."
            
            # Add missing gems
            for gem in "${missing_gems[@]}"; do
                if [ "$gem" = "jekyll-remote-theme" ]; then
                    if ! grep -q "group :jekyll_plugins" "$gemfile"; then
                        echo "" >> "$gemfile"
                        echo "group :jekyll_plugins do" >> "$gemfile"
                        echo "  gem \"jekyll-remote-theme\", \"0.4.3\"" >> "$gemfile"
                        echo "end" >> "$gemfile"
                    else
                        # Add to existing group if not already there
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
                    # Add image_processing gem (not in plugins group)
                    if ! grep -q "image_processing" "$gemfile"; then
                        echo "" >> "$gemfile"
                        echo "# Image processing for automatic image resizing" >> "$gemfile"
                        echo "gem \"image_processing\", \"~> 1.12\"" >> "$gemfile"
                    fi
                fi
            done
            
            print_success "Added missing gems to ${gemfile}"
        else
            print_info "${gemfile} already contains all required gems. Skipping..."
        fi
        return
    fi
    
    print_info "Creating ${gemfile}..."
    download_file "Gemfile.template" "$gemfile"
    print_success "Created ${gemfile}"
}

# Download plugin
download_plugin() {
    local plugin_dir="_plugins"
    
    print_info "Setting up Jekyll plugins..."
    
    mkdir -p "$plugin_dir"
    
    # Download sections_generator.rb (always overwrite)
    local plugin_file="${plugin_dir}/sections_generator.rb"
    if [ -f "$plugin_file" ]; then
        print_info "Updating ${plugin_file}..."
    else
        print_info "Downloading sections_generator.rb..."
    fi
    download_file "_plugins/sections_generator.rb" "$plugin_file"
    print_success "Downloaded/Updated sections_generator.rb"
    
    # Download image_resizer.rb (always overwrite)
    local image_resizer_file="${plugin_dir}/image_resizer.rb"
    if [ -f "$image_resizer_file" ]; then
        print_info "Updating ${image_resizer_file}..."
    else
        print_info "Downloading image_resizer.rb..."
    fi
    download_file "_plugins/image_resizer.rb" "$image_resizer_file"
    print_success "Downloaded/Updated image_resizer.rb"
    
    print_success "Jekyll plugins setup completed"
}

# Create example section
create_example_section() {
    local section_dir="_sections/tech-bites"
    local config_file="${section_dir}/config.yml"
    local page_file="${section_dir}/page.md"
    
    print_info "Creating example section: tech-bites..."
    
    mkdir -p "$section_dir"
    
    if [ ! -f "$config_file" ]; then
        download_file "_sections/tech-bites/config.yml.template" "$config_file"
        print_success "Created ${config_file}"
    else
        print_warning "${config_file} already exists. Skipping..."
    fi
    
    if [ ! -f "$page_file" ]; then
        download_file "_sections/tech-bites/page.md.template" "$page_file"
        print_success "Created ${page_file}"
    else
        print_warning "${page_file} already exists. Skipping..."
    fi
}

# Create GitHub Actions workflow
create_workflow() {
    local workflow_dir=".github/workflows"
    local workflow_file="${workflow_dir}/jekyll.yml"
    local template_url="${THEME_BASE_URL}/.github/workflows/jekyll.yml.template"
    
    print_info "Setting up GitHub Actions workflow..."
    
    mkdir -p "$workflow_dir"
    
    if [ -f "$workflow_file" ]; then
        print_warning "${workflow_file} already exists. Skipping..."
        return
    fi
    
    print_info "Creating GitHub Actions workflow..."
    download_file ".github/workflows/jekyll.yml.template" "$workflow_file"
    print_success "Created GitHub Actions workflow"
}

# Main setup function
main() {
    echo ""
    echo "=========================================="
    echo "  Spectrum-Eager Theme Setup"
    echo "=========================================="
    echo ""
    
    # Check prerequisites
    check_git_repo
    
    # Extract GitHub information
    extract_github_info
    
    echo ""
    print_info "Starting setup process..."
    echo ""
    
    # Create/update files
    create_config_yml
    create_index_md
    create_films_md
    create_gemfile
    download_plugin
    create_example_section
    create_workflow
    
    echo ""
    echo "=========================================="
    print_success "Setup completed successfully!"
    echo "=========================================="
    echo ""
    print_info "Next steps:"
    echo "  1. Review and customize _config.yml with your information"
    echo "  2. Install dependencies: bundle install"
    echo "  3. Test locally: bundle exec jekyll serve"
    echo "  4. Visit http://localhost:4000 in your browser"
    echo ""
    print_info "To deploy to GitHub Pages:"
    echo "  1. Push your changes to GitHub"
    echo "  2. Go to Settings > Pages in your repository"
    echo "  3. Set Source to 'GitHub Actions'"
    echo ""
    print_warning "Don't forget to customize _config.yml with your personal information!"
    echo ""
}

# Run main function
main
