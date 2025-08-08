# frozen_string_literal: true

require_relative "menu"

module Decidim
  module Theme
    module Maker
      class AdminEngine < ::Rails::Engine
        isolate_namespace Decidim::Theme::Maker::Admin

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        routes do
          constraints(->(request) { Decidim::Admin::OrganizationDashboardConstraint.new(request).matches? }) do
            resources :theme_maker, path: "", only: [:index, :new, :create, :edit, :update, :destroy], controller: "decidim/admin/theme_maker"
          end
        end

        initializer "decidim_theme_maker.mount_routes" do
          Decidim::Core::Engine.routes do
            mount Decidim::Theme::Maker::AdminEngine, at: "/admin/theme_maker", as: "decidim_admin_theme_maker"
          end
        end

        initializer "decidim_theme_maker.admin_menu" do
          Decidim::Theme::Maker::Menu.register_admin_menu_modules!
        end

        initializer "decidim_theme_maker.register_icons" do
          Decidim.icons.register(
            name: "paint-brush-line",
            icon: "paint-brush-line",
            category: "system",
            description: "",
            engine: :theme_maker
          )
        end
      end
    end
  end
end
