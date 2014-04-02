
module Bixby
  module Provision

    class Inventory < Base

      EXPORTS = []

      def tags(*args)
        puts "would register tags: #{args}"
      end

    end

    register_dsl Inventory

  end
end
