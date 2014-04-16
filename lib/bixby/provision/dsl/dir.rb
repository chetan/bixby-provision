
module Bixby
  module Provision

    class DirDSL < Base

      EXPORTS = []

      def create(path, opts={})
        logger.info "ensuring #{path} exists"
        FileUtils.mkdir_p(path) if !File.exists? path
        chown(path, opts.delete(:chown))
      end

      def recreate(path, opts={})
      end

      def chown(path, chown, opts={})
        chown.strip! if !chown.nil?
        return if chown.empty?

        user, group = chown.split(/:/)
        user = Process.uid if user == "$USER"
        group = Process.gid if group == "$GROUP"
        uid = get_uid(user)
        gid = get_gid(group)

        logger.info "ensuring ownership matches '#{get_user(uid)}" + (gid ? ":#{get_group(gid)}'" : "'")

        if opts[:recurse] or opts[:recursively] then
          FileUtils.chown_R(uid, gid, [path])
        else
          File.chown(uid, gid, path)
        end
      end

    end

    register_dsl DirDSL, "dir"

  end
end
