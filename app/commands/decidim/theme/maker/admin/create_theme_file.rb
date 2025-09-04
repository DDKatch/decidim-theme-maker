# frozen_string_literal: true

module Decidim::Theme::Maker::Admin
  # A command with all the business logic to create a theme file.
  class CreateThemeFile < Decidim::Command
    # Public: Initializes the command.
    #
    # form - A form object with the params.
    # current_user - The current user.
    # organization - The organization.
    def initialize(form, current_user, organization)
      @form = form
      @current_user = current_user
      @organization = organization
    end

    # Executes the command. Broadcasts these events:
    #
    # - :ok when everything is valid.
    # - :invalid if the form was not valid and we could not proceed.
    #
    # Returns nothing.
    def call
      return broadcast(:invalid) if form.invalid?

      theme_file = build_theme_file

      if theme_file.valid?
        Decidim.traceability.perform_action!(:create, theme_file, current_user) do
          theme_file.save!
          broadcast(:ok, theme_file)
        end
      else
        form.errors.merge!(theme_file.errors)
        broadcast(:invalid)
      end
    end

    private

    attr_reader :form, :current_user, :organization

    def build_theme_file
      Decidim::Theme::Maker::ThemeFile.new(
        organization: @organization,
        page_url: form.page_url,
        global: form.global,
        file: form.file
      )
    end
  end
end
