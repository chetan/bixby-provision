
require "bixby/provision/dsl/util/file"

module Bixby
  module Provision

    class Base

      include Bixby::Log
      extend Bixby::Log
      include Bixby::ScriptUtil
      include Bixby::Provision::Util::File

      PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

      attr_accessor :manifest, :proxy

      def initialize(obj=nil)
        if obj.kind_of? Base then
          @manifest = obj.manifest
          @proxy    = obj.proxy
        end
      end

      def tap(&block)
        self.instance_eval(&block)
      end

      def get_uid(user)
        return user if user.nil? or user.kind_of? Fixnum
        begin
          return Etc.getpwnam(user).uid
        rescue ArgumentError => ex
          # TODO raise
          logger.warn("Username '#{user}' was invalid: #{ex.message}")
        end
        nil
      end

      def get_user(uid)
        begin
          return Etc.getpwuid(uid).name
        rescue ArgumentError => ex
          # TODO raise
          logger.warn("Username '#{user}' was invalid: #{ex.message}")
        end
        nil
      end

      def get_gid(group)
        return group if group.nil? or group.kind_of? Fixnum
        begin
          return Etc.getgrnam(group).gid
        rescue ArgumentError => ex
          # TODO raise
          logger.warn("Group '#{group}' was invalid: #{ex.message}")
        end
        nil
      end

      def get_group(gid)
        begin
          return Etc.getgrgid(gid).name
        rescue ArgumentError => ex
          # TODO raise
          logger.warn("Group '#{group}' was invalid: #{ex.message}")
        end
        nil
      end

    end

  end
end
