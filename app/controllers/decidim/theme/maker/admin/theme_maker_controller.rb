# frozen_string_literal: true

module Decidim::Theme::Maker::Admin
  # Controller that allows managing theme files for the organization.
  class ThemeMakerController < ApplicationController
    # TODO add permission everywhere
    # include ::Decidim::NeedsPermission
    helper Decidim::Theme::Maker::ApplicationHelper

    add_breadcrumb_item_from_menu :admin_settings_menu

    def index
      # enforce_permission_to :read, :theme_file
      #
      @theme_files = Decidim::Theme::Maker::ThemeFile
        .where(organization: current_organization)
        .order(created_at: :desc)
    end

    def new
      # enforce_permission_to :create, :theme_file
      @form = form(ThemeFileForm).instance
    end

    def create
      # enforce_permission_to :create, :theme_file

      @form = form(ThemeFileForm).from_params(params)

      CreateThemeFile.call(@form, current_user, current_organization) do
        on(:ok) do
          flash[:notice] = I18n.t("theme_maker.create.success", scope: "decidim.admin")
          redirect_to theme_maker_index_path
        end

        on(:invalid) do
          flash.now[:alert] = I18n.t("theme_maker.create.error", scope: "decidim.admin")
          render :new
        end
      end
    end

    def edit
      # enforce_permission_to :update, :theme_file, theme_file: theme_file
      @form = form(ThemeFileForm).from_model(theme_file)
    end

    def update
      # enforce_permission_to :update, :theme_file, theme_file: theme_file
      @form = form(ThemeFileForm).from_params(params)

      UpdateThemeFile.call(@form, theme_file, current_user) do
        on(:ok) do
          flash[:notice] = I18n.t("theme_maker.update.success", scope: "decidim.admin")
          redirect_to theme_maker_index_path
        end

        on(:invalid) do
          flash.now[:alert] = I18n.t("theme_maker.update.error", scope: "decidim.admin")
          render :edit
        end
      end
    end

    def destroy
      # enforce_permission_to :destroy, :theme_file, theme_file: theme_file

      DestroyThemeFile.call(theme_file, current_user) do
        on(:ok) do
          flash[:notice] = I18n.t("theme_maker.destroy.success", scope: "decidim.admin")
        end

        on(:invalid) do
          flash[:alert] = I18n.t("theme_maker.destroy.error", scope: "decidim.admin")
        end
      end

      redirect_to theme_maker_index_path
    end

    private

    def theme_file
      @theme_file ||= current_organization.theme_files.find(params[:id])
    end
  end
end
