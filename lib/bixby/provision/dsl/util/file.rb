
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

          logger.info "[file] ensuring ownership matches '#{get_user(uid)}" + (gid ? ":#{get_group(gid)}'" : "'")

          # always as root
          if opts[:recurse] or opts[:recursively] then
            logged_sudo("chown -R #{uid}:#{gid} #{path}")
          else
            logged_sudo("chown #{uid}:#{gid} #{path}")
          end
        end

        # Change mode of the given path
        #
        # @param [String] path
        # @param [String] mode        File mode given as a string, same as the input to the `chmod` command
        def chmod(path, mode, opts={})
          return if mode.nil?

          if mode.kind_of? String then
            mode.strip!
            return if mode.empty?

          elsif mode.kind_of? Fixnum then
            # mode should always be a string
            # convert fixnum to octal
            mode = sprintf("%o", mode)
            if mode.length > 4 then
              # only want the right-most 4 chars
              # ex: File.stat = mode=0100440 (file r--r-----) => 33056 => "100440" => "0440"
              mode = mode[mode.length-4, mode.length]
            end
          end

          logger.info "[file] ensuring mode matches '#{mode}'"

          # always as root
          if opts[:recurse] or opts[:recursively] then
            logged_sudo("chmod -R #{mode} #{path}")
          else
            logged_sudo("chmod #{mode} #{path}")
          end
        end

      end
    end
  end
end
