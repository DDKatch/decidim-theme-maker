require_relative "lib/decidim/theme/maker/version"

Gem::Specification.new do |spec|
  spec.name        = "decidim-theme-maker"
  spec.version     = Decidim::Theme::Maker::VERSION
  spec.authors     = ["Daniil Kachur"]
  spec.email       = ["kachur.daniil@gmail.com"]
  spec.homepage    = "https://decidim.org"
  spec.summary     = "Decidim theme maker module"
  spec.description = "A module for uploading and managing CSS files for organizations."
  spec.license     = "AGPL-3.0-or-later"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/decidim/decidim"
  spec.metadata["changelog_uri"] = "https://github.com/decidim/decidim/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.8.4"
  spec.add_dependency "decidim-core", "~> 0.30.0"
  spec.add_dependency "decidim-admin", "~> 0.30.0"
end
