# frozen_string_literal: true

module Decidim::Theme::Maker::Admin
  # A command with all the business logic to destroy a theme file.
  class DestroyThemeFile < Decidim::Command
    # Public: Initializes the command.
    #
    # theme_file - The theme file to destroy.
    # current_user - The current user.
    def initialize(theme_file, current_user)
      @theme_file = theme_file
      @current_user = current_user
    end

    # Executes the command. Broadcasts these events:
    #
    # - :ok when everything is valid.
    # - :invalid if the theme file could not be destroyed.
    #
    # Returns nothing.
    def call
      Decidim.traceability.perform_action!(:delete, theme_file, current_user) do
        theme_file.destroy!
      end

      broadcast(:ok, theme_file)
    rescue ActiveRecord::RecordNotDestroyed
      broadcast(:invalid, theme_file)
    end

    private

    attr_reader :theme_file, :current_user
  end
end
