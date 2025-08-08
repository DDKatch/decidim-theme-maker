# frozen_string_literal: true

module Decidim
  module Admin
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user
        return permission_action unless user.admin?
        return permission_action unless permission_action.scope == :admin

        case permission_action.subject
        when :theme_file
          case permission_action.action
          when :read, :create, :update, :destroy
            allow!
          end
        end

        permission_action
      end
    end
  end
end 