
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

        # Get the SHA-256 hex digest of the given file
        #
        # @param [String] filename
        #
        # @return [String] sha256 hash in hexadecimal form
        def sha256sum(filename)
          if ::File.readable? filename then
            return Digest::SHA2.new(256).file(filename).hexdigest()
          end

          # read as root
          if cmd = which("sha256sum") then
            return logged_sudo("#{cmd} #{filename}").stdout.split(/\s+/).first
          end

          # use cat - may not work for binaries
          str = logged_sudo("cat #{filename}").stdout
          return Digest::SHA2.new(256).update(str).hexdigest()
        end

        # Locate the given command, if it exists
        #
        # @param [String] cmd     to locate
        #
        # @return [String] path to command if it exists, or nil
        def which(cmd)
          ret = systemu("which #{cmd}")
          if ret.success? then
            return ret.stdout.strip
          else
            return nil
          end
        end
        alias_method :command_exists?, :which

      end
    end
  end
end
