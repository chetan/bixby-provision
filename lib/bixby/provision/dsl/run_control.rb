
module Bixby
  module Provision

    class RunControl < Base

      EXPORTS = [:first_boot]

      def first_boot(&block)
        if first_boot_has_run? then
          logger.info "first_boot already ran"
        end
        logger.info "running first_boot block"
        begin
          block.call
        rescue Exception => ex
          # TODO fail!
          raise ex
          return
        end

        touch_first_boot_state
      end


      private

      def first_boot_has_run?
        File.exists?(first_boot_state)
      end

      def first_boot_state
        Bixby.path("var", "provision", "first_boot")
      end

      def touch_first_boot_state
        f = first_boot_state
        FileUtils.mkdir_p(File.dirname(f))
        FileUtils.touch(f)
      end

    end

    register_dsl RunControl, "run_control"

  end
end
