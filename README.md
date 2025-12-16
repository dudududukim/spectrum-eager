# Spectrum - Minimal Jekyll Theme


[![Jekyll](https://img.shields.io/badge/Jekyll-%3E%3D%204.3-blue.svg?style=flat&height=20)](https://jekyllrb.com/)
[![Ruby](https://img.shields.io/badge/Ruby-%3E%3D%203.2-red.svg?style=flat&height=20)](https://www.ruby-lang.org/)
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg?style=flat&height=20)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/dudududukim/spectrum.svg?style=flat&height=20&label=Star)](https://github.com/dudududukim/spectrum)
[![Featured on Jekyll Themes](https://img.shields.io/badge/featured%20on-JT-red.svg?style=flat&height=20)](https://jekyll-themes.com/dudududukim/spectrum)


<div align="center">

### 🚀 **LIVE DEMO**
**[dudududukim.github.io/spectrum/](https://dudududukim.github.io/spectrum/)**

_👆 Click here to see the live demo!_

</div>

![Homepage Light](images/white_main.png)

A clean and minimal **Jekyll theme** designed for personal websites and blogs with a focus on simplicity and customizability. Perfect for professional researchers, undergraduates, and creators from diverse backgrounds who want an easy-to-use yet flexible platform.

# Spectrum Jekyll Theme

A minimal, responsive Jekyll theme with excellent typography and dynamic color theming. Perfect for developers, researchers, and creatives who want a clean, professional website.

## ✨ Key Features

- **Dynamic Primary Color System** - Change one color in `_config.yml` to instantly personalize your entire site
- **Dual Content Types**: 
  - **Tech Bites**: Blog posts, paper summaries, or journal entries
  - **Films**: Photography gallery with markdown descriptions and metadata
- **Responsive Design** with mobile-first approach
- **Light & Dark Theme** support with automatic switching
- **Minimal & Clean** design focused on readability
- **GitHub Actions** deployment ready


## Quick Start

### Prerequisites
- Ruby 3.2+ and Bundler
- Git

### Installation
1. Clone the repo
```
git clone https://github.com/dudududukim/spectrum.git
cd spectrum
```
2. Install dependencies
```
bundle install
```
3. Configure your site
   - Edit `_config.yml` to update site details, personal bio, and colors

4. **Enable GitHub Pages deployment**
   - Go to **Settings > Pages** in your GitHub repository
   - Set **Source** to "**GitHub Actions**"

5. Run locally
```
bundle exec jekyll serve
```
6. Visit `http://localhost:4000` in your browser

## Usage & Customization

### Tech Bites Section
- **Versatile content space**: Use for blog posts, paper summaries, research notes, or general articles
- Create Markdown files in `_tech-bites/` with proper front matter
- Perfect for sharing insights, tutorials, or academic work

### Films Section
- **Photography showcase**: Upload your own photos or hobby images
- **Rich descriptions**: Add Markdown files to provide context, stories, or technical details about your photos
- Great for visual portfolios or travel documentation

### Dynamic Theming
- **One-click personalization**: Change the `primary` color in `_config.yml` to instantly transform your site's appearance
- All UI elements automatically adapt to your chosen color scheme

## Deployment

### GitHub Pages
This **Jekyll theme** is ready for immediate deployment with GitHub Actions.
- Workflow file `.github/workflows/jekyll.yml` is included and ready to use
- Simply enable GitHub Actions as the source in **Settings > Pages**
- Push your changes and watch your site deploy automatically!

### Other Platforms
- **Netlify**: Auto-detects Jekyll and builds automatically
- **Vercel**: Compatible with standard Jekyll builds
- **Self-hosted**: Use `bundle exec jekyll build` for static files

## 🎨 Live Preview

### Homepage Overview
| Light Theme | Dark Theme |
|-------------|------------|
| ![Homepage Light](images/white_main.png) | ![Homepage Dark](images/dark_main.png) |

### Content Sections
| Tech Bites | Films Gallery |
|------------|---------------|
| ![Tech Bites Light](images/white_tech.png) | ![Films Light](images/white_films.png) |
| ![Tech Bites Dark](images/dark_tech.png) | ![Films Dark](images/dark_films.png) |

### Individual Content Pages
| Markdown Content | Photo detail page |
|------------------|-------------------|
| ![Tech Markdown Light](images/white_tech_md.png) | ![Films Photo Light](images/white_films_photo.png) |
| ![Tech Markdown Dark](images/dark_tech_md.png) | ![Films Photo Dark](images/dark_films_photo.png) |



## Project Structure

```
spectrum/
├── .github/
│   └── workflows/
│       └── jekyll.yml    # GitHub Actions workflow (included)
├── _data/
│   └── navigation.yml    # Navigation configuration
├── _includes/            # Reusable components
├── _layouts/             # Page templates
├── _sass/                # Stylesheets
├── _tech-bites/          # Blog posts / tech bites / papers
├── _films/               # Photography markdown files
├── assets/               # Images and CSS
├── _config.yml           # Site configuration including colors
├── 404.html              # Custom 404 page
├── index.md              # Homepage
├── tech-bites.md         # Blog listing
├── films.md              # Photography page
├── LINCESE.txt           # License file
└── README.md
```

## Development

Use `bundle exec jekyll serve` for local development with live reload.

## Contributing

Fork the repository, create a feature branch, commit your changes, and open a pull request.

## Author

**Duhyeon Kim**
- GitHub: [@dudududukim](https://github.com/dudududukim)
- LinkedIn: [Duhyeon Kim](https://www.linkedin.com/in/duhyeon-kim-6623082b1/)

## License

MIT License. See LINCESE.txt file for details.

## Support

Submit issues via GitHub Issues or check inline documentation in code files.

---

## Show Your Support

**⭐ If you find this Jekyll theme helpful, please give it a star on GitHub!** Your support helps maintain and improve this project for everyone.

**⭐ Star this repository** to show your appreciation and help others discover this theme!

---

**Built with Jekyll**
