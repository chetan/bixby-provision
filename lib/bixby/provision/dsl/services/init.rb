
module Bixby
  module Provision
    module Services

      class Init < ServiceBase

        def start(name, opts={})
          init("#{name} start")
        end

        def stop(name, opts={})
          init("#{name} stop")
        end

        def restart(name, opts={})
          init("#{name} restart")
        end

        def reload(name, opts={})
          init("#{name} reload")
        end

        def running?(name)
          cmd = init("#{name} status")
          return cmd.success? # exit 0 means it's running (usually.. hopefully!)
        end


        private

        def init(args)
          logged_sudo("/etc/init.d/#{args}")
        end

      end

    end
  end
end
