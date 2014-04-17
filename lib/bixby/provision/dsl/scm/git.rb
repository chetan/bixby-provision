
require "git"

module Bixby
  module Provision
    class SCM < Base

      class Git < SCMBase

        def checkout(uri, opts)
          path   = opts.delete(:path)
          branch = opts.delete(:branch) || "master"

          if path.nil? then
            # TODO raise
          end
          path = File.expand_path(path)
          if File.directory? File.join(path, ".git") then
            logger.info "repository already checked out at #{path}"
            return
          end
          dir.create(path)

          logger.info "cloning #{uri} into #{path}, branch: #{branch}"
          g = ::Git.clone(uri, File.basename(path), :path => File.dirname(path))
          g.checkout(branch) if branch != "master"
        end

      end

    end
  end
end
