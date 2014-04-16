
module Bixby
  module Provision
    module Packager

      class NPM < Base

        def install(*packages)
          if packages.last.kind_of? Hash then
            opts = packages.pop
          else
            opts = {}
          end
          packages.flatten!

          global = opts.delete(:global)
          cmd = "npm install " + (global ? "-g " : "") + packages.join(" ")
          logged_sudo(cmd)
        end


        private

      end

    end
  end
end
