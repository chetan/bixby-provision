
module Bixby
  module Provision

    class App

      include Bixby::ScriptUtil
      include Bixby::Log

      def initialize
      end

      def run!
        file = ARGV.shift

        if file == "--" then
          logger.info "reading manifest on STDIN"
          str = read_stdin()
          t = Tempfile.new("bixby-provision-")
          t.write(str)
          t.close
          file = t.path
        end

        file = File.expand_path(file)
        logger.info "reading manifest from file #{file}"
        Bixby::Provision::Manifest.new(file)
      end

    end

  end
end
