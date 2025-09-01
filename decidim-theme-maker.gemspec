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
  spec.add_dependency "mutex_m", "~> 0.3.0" # activesupport missed dependency
  spec.add_dependency "decidim-core", Decidim::Theme::Maker::DECIDIM_VERSION
  spec.add_dependency "decidim-admin", Decidim::Theme::Maker::DECIDIM_VERSION
  spec.add_dependency "decidim-api", Decidim::Theme::Maker::DECIDIM_VERSION

  # spec.add_dependency "decidim-generators", Decidim::Theme::Maker::DECIDIM_VERSION
  spec.add_dependency "puma", "~> 6.5"
  spec.add_dependency "stimulus-rails", "~> 1.3.4"

  spec.add_development_dependency "decidim-dev", Decidim::Theme::Maker::DECIDIM_VERSION
end
