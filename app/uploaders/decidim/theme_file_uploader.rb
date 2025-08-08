# frozen_string_literal: true

module Decidim
  # This class deals with uploading CSS files for themes
  class ThemeFileUploader < ApplicationUploader
    def validable_dimensions
      false
    end

    def extension_allowlist
      %w(css)
    end

    def content_type_allowlist
      %w(text/css)
    end

    def max_file_size
      5.megabytes
    end

    def max_image_height_or_width
      nil
    end

    protected

    def upload_context
      :admin
    end
  end
end 