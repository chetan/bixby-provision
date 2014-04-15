
module Bixby
  module Provision

    class NTP < Base

      EXPORTS = []

      DEFAULT_NTP_POOL = "ntp.ubuntu.com"

      def initialize(*args)
        super
        @service = if ubuntu? then
            "ntp"
          elsif centos? or amazon? then
            "ntpd"
          end
      end

      def set(server=DEFAULT_NTP_POOL)
        logger.info "ntp.set using #{server}"
        sys.package "ntpdate"
        stop
        logged_sudo("ntpdate #{server}", :env => { "PATH" => PATH } )
        start
      end

      def start
        service.start @service
      end

      def stop
        service.stop @service
      end

    end

    register_dsl NTP

  end
end
