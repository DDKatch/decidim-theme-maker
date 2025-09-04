# frozen_string_literal: true

module Decidim::Theme::Maker::Admin
  # A command with all the business logic to update a theme file.
  class UpdateThemeFile < Decidim::Command
    # Public: Initializes the command.
    #
    # form - A form object with the params.
    # theme_file - The theme file to update.
    # current_user - The current user.
    def initialize(form, theme_file, current_user)
      @form = form
      @theme_file = theme_file
      @current_user = current_user
    end

    # Executes the command. Broadcasts these events:
    #
    # - :ok when everything is valid.
    # - :invalid if the form was not valid and we could not proceed.
    #
    # Returns nothing.
    def call
      return broadcast(:invalid) if form.invalid?

      update_theme_file

      if theme_file.valid?
        Decidim.traceability.perform_action!(:update, theme_file, current_user) do
          theme_file.save!
          broadcast(:ok, theme_file)
        end
      else
        form.errors.merge!(theme_file.errors)
        broadcast(:invalid)
      end
    end

    private

    attr_reader :form, :theme_file, :current_user

    def update_theme_file
      theme_file.assign_attributes(
        page_url: form.page_url,
        global: form.global.nil? ? false : form.global
      )

      theme_file.file = form.file if form.file.present?
    end
  end
end
