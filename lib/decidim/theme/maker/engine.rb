# frozen_string_literal: true
require "rails"
require "decidim/core"

module Decidim
  module Theme
    module Maker
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Theme::Maker

        initializer "decidim_theme_maker.load_tasks" do
          load_tasks
        end

        initializer "decidim_theme_maker.webpacker.assets_path" do
          Decidim.register_assets_path File.expand_path("app/packs", root)
        end
      end
    end
  end
end
