
require "bixby-common"
require "bixby-client"

module Bixby
  module Provision

    def self.register_dsl(obj, name=nil)

      # create a simple name if none given
      # "Bixby::Provision::Config" > :config
      if name.nil? then
        name = obj.name.split(/::/).last.downcase
      end
      name = name.to_sym

      # return the dsl object via its name
      # always returns the same instance
      Manifest::DSLProxy.class_eval <<-EOF
        def #{name}
          return @#{name} if @#{name} # return already created instance

          @#{name}          = #{obj.name}.new
          @#{name}.manifest = self.manifest
          @#{name}.proxy    = self
          @#{name}
        end
      EOF

      if obj.const_defined? :EXPORTS then
        obj::EXPORTS.each do |e|

          Manifest::DSLProxy.class_eval do
            def_delegator name, e.to_sym
          end

        end
      end

      # add accessors for each DSL object
      Base.class_eval <<-EOF
        def #{name}
          self.proxy.send(:#{name})
        end
      EOF

    end

  end
end

require "bixby/provision/manifest"
require "bixby/provision/dsl"

Bixby::Log.setup_logger(:level => :info, :filename => Bixby.path("var", "provision.log"))

# enable condensed logging to stdout
Logging.appenders.stdout( 'provision_stdout',
  :auto_flushing => true,
  :layout => Logging.layouts.pattern(
    :pattern => '%.1l, [%d] %m\n',
    :color_scheme => 'bright'
  )
)
Logging::Logger.root.add_appenders("provision_stdout")
