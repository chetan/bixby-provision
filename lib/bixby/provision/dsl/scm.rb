
require "bixby/provision/dsl/scm/base"
require "bixby/provision/dsl/scm/git"
require "bixby/provision/dsl/scm/svn"

module Bixby
  module Provision

    class SCM < Base

      EXPORTS = [:checkout]

      def checkout(uri, opts={})
        handler(uri).checkout(uri, opts)
      end


      private

      def handler(uri)
        @handler ||= if uri =~ %r{\.git$} then
            SCM::Git.new(self)
          else
            # TODO add check
            SCM::SVN.new(self)
          end
      end

    end

    register_dsl SCM

  end
end
