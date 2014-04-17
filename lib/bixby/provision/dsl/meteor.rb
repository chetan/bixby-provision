
module Bixby
  module Provision

    class Meteor < Base

      EXPORTS = []

      def install(opts={})
        if File.exists? "/usr/local/bin/meteor" then
          logger.info "meteor already installed; skipping"
          return
        end

        logger.info "installing meteor"
        logged_systemu("curl -sL https://install.meteor.com | sh")
      end

    end

    register_dsl Meteor

  end
end
