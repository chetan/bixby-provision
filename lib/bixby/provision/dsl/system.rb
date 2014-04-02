
module Bixby
  module Provision

    class System

      EXPORTS = [:refresh_packages, :upgrade_system, :package]

      def refresh_packages
        puts "refreshing"
      end

      def upgrade_system
        puts "uprading system"
      end

      def package(*args)
      end

    end

    register_dsl System, "sys"

  end
end
