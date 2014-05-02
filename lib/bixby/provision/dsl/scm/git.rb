
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

          # https://github.com/user/repo.git
          # git@github.com:user/repo.git
          # ssh://hg@bitbucket.org/user/repo
          if uri !~ %r{https?://} && uri =~ %r{^(ssh://)?(.*?@)(.*?)[:/]} then
            ensure_ssh_verify($3)
          end

          sys.package "git"
          require "git" # lazy require here, because loading will try to run `git --version`

          logger.info "[scm] cloning #{uri} into #{path}, branch: #{branch}"
          g = ::Git.clone(uri, File.basename(path), :path => File.dirname(path))
          g.checkout(branch) if branch != "master"
        end


        private

        # Ensure that StrictHostKeyChecking is disabled for the given host
        #
        # @param [String] host
        def ensure_ssh_verify(host)

          config = File.expand_path("~/.ssh/config")
          str = ""
          str = File.read(config) if File.exists? config

          add = str.empty?
          if !add then
            # see if it's already disabled for the given host
            found_host = false
            found_strict = false
            str.split(/n/).each do |l|

              if l =~ /^\s*Host (.*?)/ then
                if found_host then
                  add = true if !found_strict
                  found_host = false
                  next
                end
                if $1 == host then
                  found_host = true
                end

              elsif found_host && l =~ /StrictHostKeyChecking \s*no/ then
                found_strict = true
              end
            end
          end

          return if !add

          logger.info "[scm] disabling StrictHostKeyChecking for #{host}"
          str += "\n"
          str += "Host #{host}\n"
          str += "  StrictHostKeyChecking no\n"

          dir.mkdir "~/.ssh", :chmod => "700"
          File.open(config, 'w'){ |f| f.write(str) }
          chmod config, "644"
        end

      end

    end
  end
end
