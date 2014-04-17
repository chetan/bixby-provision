
module Bixby
  module Provision

    class DirDSL < Base

      EXPORTS = []

      def create(path, opts={})
        logger.info "ensuring #{path} exists"
        begin
          FileUtils.mkdir_p(path) if !File.exists? path
          chown(path, opts.delete(:chown))
        rescue Errno::EACCES => ex
          logger.info "[dir] permission denied, trying again with sudo"
          logged_sudo("mkdir -p #{path}")
          chown(path, opts.delete(:chown))
        end
      end

      def recreate(path, opts={})
      end

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

    register_dsl DirDSL, "dir"

  end
end
