
module Bixby
  module Provision

    class Meteor < Base

      EXPORTS = []

      def install(opts={})
        if File.exists? "/usr/local/bin/meteor" then
          logger.info "meteor already installed; skipping"
          return
        end

        logger.info "[meteor] installing meteor"
        logged_systemu("curl -sL https://install.meteor.com | sh")
      end

      # Run meteorite install
      def mrt(path, opts={})
        logger.info "[meteor] mrt install"
        logged_systemu("mrt install", :cwd => File.expand_path(path))
      end

    end

    register_dsl Meteor

  end
end
