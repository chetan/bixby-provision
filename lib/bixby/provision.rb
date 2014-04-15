
require "bixby-common"
require "bixby-client"

module Bixby
  module Provision

    def self.register_dsl(obj, name=nil)

      # if !obj.const_defined? :EXPORTS then
      #   raise "#{obj} doesn't have an EXPORTS constant!"
      # end

      if name.nil? then
        name = obj.name.split(/::/).last.downcase
      end
      name = name.to_sym

      Manifest::DSLProxy.class_eval <<-EOF
        def #{name}
          @#{name} ||= #{obj.name}.new
        end
      EOF

      if obj.const_defined? :EXPORTS then
        obj::EXPORTS.each do |e|

          Manifest::DSLProxy.class_eval do
            def_delegator name, e.to_sym
          end

        end
      end

    end

  end
end

require "bixby/provision/manifest"
require "bixby/provision/dsl"

Bixby::Log.setup_logger(:filename => Bixby.path("var", "provision.log"))
