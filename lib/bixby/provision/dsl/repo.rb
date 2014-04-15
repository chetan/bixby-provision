
require "bixby/provision/dsl/repo/base"
require "bixby/provision/dsl/repo/apt"
require "bixby/provision/dsl/repo/yum"
require "bixby/provision/dsl/repo/epel"

module Bixby
  module Provision

    class Repo < Base

      EXPORTS = [:repo]

      KNOWN_REPOS = {
        "apt"  => Apt,
        "yum"  => Yum,
        "epel" => Epel,
      }

      def repo(name, opts={})
        install_repo(name, opts)
      end

      def install_repo(name, opts={})
        logger.info "install_repo #{name}"
        if KNOWN_REPOS.include? name then
          KNOWN_REPOS[name].new.install
        end
      end

    end

    register_dsl Repo, "repos"

  end
end
