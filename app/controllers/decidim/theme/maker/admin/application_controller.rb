# frozen_string_literal: true

module Decidim::Theme::Maker::Admin
  class ApplicationController < Decidim::Admin::ApplicationController
    register_permissions(::Decidim::Theme::Maker::Admin::ApplicationController,
                         Decidim::Theme::Maker::Admin::Permissions,
                         Decidim::Admin::Permissions)
  end
end
