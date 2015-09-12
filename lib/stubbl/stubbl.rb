
##
# Stubbl
#
module Stubbl
  class << self
    ##
    # Load the Web API
    #
    # Loads the RESTful API Application
    def load_api
      require 'stubbl/api/api'
    end

    ##
    # Load the CLI
    #
    # Loads the CLI layer (used by cli app)
    def load_cli
      require 'stubbl/cli/cli'
    end

    #self.root = File.expand_path(File.dirname(File.dirname __FILE__))
  end

end

require 'bundler'

Bundler.require :default


$LOAD_PATH << File.expand_path(File.dirname(File.dirname __FILE__))

require 'stubbl/lib/settings'
