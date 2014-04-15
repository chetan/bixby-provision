
module Bixby
  module Provision
    class Repo < Base

      class Yum < RepoBase

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
