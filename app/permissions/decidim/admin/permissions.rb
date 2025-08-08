# frozen_string_literal: true

module Decidim
  module Admin
    class Permissions < Decidim::DefaultPermissions
      def permissions
        # Always run Decidim defaults first so core admin permissions and menu visibility work
        super

        return permission_action unless permission_action.scope == :admin

        # Ensure admin dashboard permission is decided to avoid PermissionNotSetError
        if permission_action.subject == :admin_dashboard && permission_action.action == :read
          allow! if user&.admin?
          return permission_action
        end

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