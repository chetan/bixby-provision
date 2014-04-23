
module Bixby
  module Provision
    module Util

      module File

        def chown(path, chown, opts={})
          if chown.nil? then
            return
          end
          chown.strip!
          return if chown.empty?

          user, group = chown.split(/:/)
          user = Process.uid if user == "$USER"
          group = Process.gid if group == "$GROUP"
          uid = get_uid(user)
          gid = get_gid(group)

          logger.info "[dir] ensuring ownership matches '#{get_user(uid)}" + (gid ? ":#{get_group(gid)}'" : "'")

          # always as root
          if opts[:recurse] or opts[:recursively] then
            logged_sudo("chown -R #{uid}:#{gid} #{path}")
          else
            logged_sudo("chown #{uid}:#{gid} #{path}")
          end
        end

      end

    end
  end
end
