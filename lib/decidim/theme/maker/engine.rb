module Decidim
  module Theme
    module Maker
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Theme::Maker

        routes do
          scope "/admin" do
            resources :theme_maker, only: [:index, :new, :create, :edit, :update, :destroy], controller: "decidim/admin/theme_maker"
          end
        end

        initializer "decidim_theme_maker.assets" do |app|
          app.config.assets.precompile += %w(decidim_theme_maker_manifest.js)
        end

        initializer "decidim_theme_maker.mount_routes", before: :add_routing_paths do
          Decidim::Core::Engine.routes do
            mount Decidim::Theme::Maker::Engine => "/"
          end
        end

        initializer "decidim_theme_maker.admin_menu" do
          Decidim.menu :admin_menu do |menu|
            menu.add_item :theme_maker,
                          I18n.t("menu.theme_maker", scope: "decidim.theme_maker"),
                          decidim_admin_theme_maker_index_path,
                          icon_name: "paint-brush",
                          position: 7.5,
                          active: :inclusive
          end
        end

        initializer "decidim_theme_maker.load_tasks" do
          load_tasks
        end
      end
    end
  end
end
