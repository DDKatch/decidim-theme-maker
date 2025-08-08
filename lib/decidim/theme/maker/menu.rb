# frozen_string_literal: true

module Decidim
  module Theme
    module Maker
      class Menu
        def self.register_admin_menu_modules!
          Decidim.menu :admin_menu do |menu|
            menu.add_item :theme_maker,
                          I18n.t("menu.theme_maker", scope: "decidim.theme_maker"),
                          "/admin/theme_maker",
                          icon_name: "paint-brush",
                          position: 7.5,
                          active: :inclusive
          end
        end
      end
    end
  end
end
