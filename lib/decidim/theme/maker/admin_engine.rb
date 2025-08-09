# frozen_string_literal: true

require "rails"
require "active_support/all"
require "decidim/core"

require_relative "menu"

module Decidim
  module Theme
    module Maker
      class AdminEngine < ::Rails::Engine
        isolate_namespace Decidim::Theme::Maker::Admin

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        route_constraint = ->(request) do
          Decidim::Admin::OrganizationDashboardConstraint.new(request).matches?
        end

        routes do
          constraints(route_constraint) do
            resources(
              :theme_maker,
              only: [:index, :new, :create, :edit, :update, :destroy],
            )
          end
        end

        initializer "decidim_theme_maker_admin.mount_routes" do
          Decidim::Core::Engine.routes do
            mount(
              Decidim::Theme::Maker::AdminEngine,
              at: "/admin",
              as: "decidim_admin_theme_maker"
            )
          end
        end

        initializer "decidim_theme_maker_admin.register_icons" do
          Decidim.icons.register(
            name: "paint-brush-line",
            icon: "paint-brush-line",
            category: "system",
            description: "",
            engine: :theme_maker
          )
        end

        initializer "decidim_theme_maker_admin.menu" do
          Decidim::Theme::Maker::Menu.register_admin_menu_modules!
        end
      end
    end
  end
end
