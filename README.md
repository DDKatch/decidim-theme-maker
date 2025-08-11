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

## Usage

1. Access the admin panel
2. Navigate to "Theme Maker" in the admin menu
3. Upload CSS files for your organization
4. The CSS will be applied to your organization's pages

## Development

To set up the development environment:

```bash
bundle install
bundle exec rake spec
```

## License

This project is licensed under the AGPL-3.0-or-later license.
