# Decidim Theme Maker

A Decidim module that allows administrators to upload and manage CSS files for their organization.

## Features

- Upload CSS files for organization customization
- Admin interface for managing theme files
- Organization-specific theme storage
- File validation and security

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-theme-maker", git: "https://github.com/DDKatch/decidim-theme-maker.git", branch: "main"

```

And then execute:

```bash
bundle install
```

### Installing Migrations

Since this is a custom module, you'll need to install the migrations manually:

**Run this command within your decidim application directory**
```bash
bundle exec rails decidim_theme_maker:install:migrations
```

### Integrating into the main application

**Run this command within your decidim application directory**
```bash
bundle exec rails decidim_theme_maker:integrate:layouts
```
## Usage

0. Visit organizatinon edit page under system admin account
1. Press 'Show advanced settings' button
3. Find 'File upload settings > Allowed file extensions > Admin file extensions' section
4. Put 'css' into the input field
5. Find 'File upload settings > Allowed file extensions > Admin MIME types' section
6. Put 'text/css' into the input field
1. Access the admin panel
8. Navigate to "Theme Maker" in the admin menu
9. Upload CSS files for your organization
10. The CSS will be applied to your organization's pages

## Development

To set up the development environment:

```bash
bundle install
bundle exec rake spec
```

## License

This project is licensed under the AGPL-3.0-or-later license.
