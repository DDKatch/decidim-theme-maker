# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Organization.class_eval do
    has_many :theme_files, foreign_key: "decidim_organization_id", class_name: "Decidim::Theme::Maker::ThemeFile", dependent: :destroy
  end
end 