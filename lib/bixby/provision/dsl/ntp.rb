
module Bixby
  module Provision

    class NTP

      EXPORTS = []

      DEFAULT_NTP_POOL = "ntp.ubuntu.com"

      def set(server=DEFAULT_NTP_POOL)
        puts "setting date via ntpdate using #{server}"
      end

    end

    register_dsl NTP

  end
end
