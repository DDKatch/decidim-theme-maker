# frozen_string_literal: true

module Decidim
  module Theme
    module Maker
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Theme::Maker

        initializer "decidim_theme_maker.load_tasks" do
          load_tasks
        end
      end
    end
  end
end
