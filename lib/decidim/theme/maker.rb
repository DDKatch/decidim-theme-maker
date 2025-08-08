require_relative "maker/version"
require_relative "maker/engine" if defined?(Rails)

module Decidim
  module Theme
    module Maker
      # Public: Returns the version of the module.
      def self.version
        VERSION
      end
    end
  end
end
