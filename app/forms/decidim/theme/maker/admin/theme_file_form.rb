# frozen_string_literal: true

module Decidim::Theme::Maker::Admin
  # A form object used to create and update theme files from the admin
  # dashboard.
  class ThemeFileForm < Decidim::Form
    include Decidim::TranslatableAttributes

    mimic :theme_file

    translatable_attribute :name, String
    translatable_attribute :description, String
    attribute :file, Decidim::Attributes::Blob

    validates :name, translatable_presence: true
    validates :description, translatable_presence: true
    validates :file, presence: true, if: :new_record?

    def map_model(model)
      self.file = model.file if model.attached?
    end

    def new_record?
      id.blank?
    end
  end
end
