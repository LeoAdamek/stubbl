
##
# Stubbl
#
module Stubbl

  # TODO: Parametize
  PRINTER_NAME = 'DYMO_LW_450'
  
  class << self
    ##
    # Load the Web API
    #
    # Loads the API Application
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

    ##
    # Load Generagtor
    #
    # Loads the Stub Generator
    def load_generator
      require 'stubbl/generator/generator'
    end
  end

end

require 'bundler'

Bundler.require :default


$LOAD_PATH << File.expand_path(File.dirname(File.dirname __FILE__))

require 'stubbl/lib/settings'
