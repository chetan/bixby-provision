
module Bixby
  module Provision

    class Repo

      EXPORTS = [:repo]

      def repo(name, opts={})
        puts "installing repo"
      end

    end

    register_dsl Repo, "repos"

  end
end
