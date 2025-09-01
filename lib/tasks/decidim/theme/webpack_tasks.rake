# frozen_string_literal: true

require "decidim/gem_manager"

namespace :decidim_theme_maker do
  namespace :webpacker do
    desc "Installs Decidim Awesome webpacker files in Rails instance application"
    task :install do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_theme_maker_npm
    end

    desc "Adds Decidim Awesome dependencies in package.json"
    task upgrade: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_theme_maker_npm
    end

    def install_theme_maker_npm
      theme_maker_npm_dependencies.each do |type, packages|
        system! "npm i --save-#{type} #{packages.join(" ")}"
      end
    end

    def theme_maker_npm_dependencies
      @theme_maker_npm_dependencies ||= begin
        package_json = JSON.parse(File.read(theme_maker_path.join("package.json")))

        {
          prod: package_json["dependencies"].map { |package, version| "#{package}@#{version}" },
          dev: package_json["devDependencies"].map { |package, version| "#{package}@#{version}" }
        }.freeze
      end
    end

    def theme_maker_path
      @theme_maker_path ||= Pathname.new(theme_maker_gemspec.full_gem_path) if Gem.loaded_specs.has_key?(gem_name)
    end

    def theme_maker_gemspec
      @theme_maker_gemspec ||= Gem.loaded_specs[gem_name]
    end

    def rails_app_path
      @rails_app_path ||= Rails.root
    end

    def system!(command)
      system("cd #{rails_app_path} && #{command}") || abort("\n== Command #{command} failed ==")
    end

    def gem_name
      "decidim-theme-maker"
    end
  end
end
