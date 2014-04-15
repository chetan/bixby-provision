
require "bixby/provision/dsl/repo/yum"

module Bixby
  module Provision
    class Repo < Base

      class Epel < RepoBase

        def install

          if !amazon? && !centos? then
            logger.info "skipping EPEL repo (not centos or amazon)"
            return
          end

        end

      end

    end
  end
end
