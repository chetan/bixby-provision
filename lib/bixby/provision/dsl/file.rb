
module Bixby
  module Provision

    class FileDSL

      EXPORTS = []

      def create(opts={})
        puts "installing ruby"
      end

    end

    register_dsl FileDSL, "file"

  end
end
