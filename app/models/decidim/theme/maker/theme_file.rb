# frozen_string_literal: true

module Decidim
  module Theme
    module Maker
      # ThemeFile represents a CSS file uploaded by an admin for their organization
      class ThemeFile < ApplicationRecord
        include Decidim::HasUploadValidations
        include Decidim::Traceable

        belongs_to :organization, class_name: "Decidim::Organization"

        has_one_attached :file
        validates_upload :file, uploader: Decidim::Theme::Maker::ThemeFileUploader

        validates :page_url, presence: true
        # Forbid multiple non-global files for the same page within an organization
        validates :page_url,
                  uniqueness: { scope: :organization_id, conditions: -> { where(global: false) } },
                  unless: :global
        attribute :global, :boolean, default: false
        # Allow only one global file per organization
        validates :global,
                  uniqueness: { scope: :organization_id, conditions: -> { where(global: true) } },
                  if: :global

        delegate :attached?, to: :file

        # Returns the CSS content as a string
        def css_content
          return nil unless attached?

          file.download.force_encoding("UTF-8")
        end

        # Returns the file size in a human readable format
        def file_size
          return nil unless attached?

          ActiveSupport::NumberHelper.number_to_human_size(file.byte_size)
        end

        # Returns the filename
        def filename
          return nil unless attached?

          file.filename.to_s
        end

        # Returns the content type
        def content_type
          return nil unless attached?

          file.content_type
        end
      end
    end
  end
end
