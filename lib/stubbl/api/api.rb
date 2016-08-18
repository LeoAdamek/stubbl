# coding: utf-8

module Stubbl::API; end

require 'sinatra'
require 'stubbl/api/atlassian_connect'
require 'stubbl/api/actions/print_stub'
require 'stubbl/api/actions/stubs'
require 'stubbl/api/ui_modules/standalone'

class Stubbl::API::App < Sinatra::Base

  set :sessions, false
  enable :logging

  use Stubbl::API::AtlassianConnect
  use Stubbl::API::Actions::PrintStub
  use Stubbl::API::Actions::Stubs
  use Stubbl::API::UIModules::Standalone

  use Rack::Cors do
    allow do
      origins 'localhost:9292',
              /(https:\/\/)?mr-zen.atlassian.net\//

      resource '/*', :methods => [:get, :post, :options],
                     :headers => :any
    end
  end

  # Run the app if it was started directly
  run! if app_file == $0
end


# Yeah, we have to money-patch Rack::Protection::FrameOptions because
# otherwise we can't be embedded. :LAME:

module Rack
  module Protection
    class FrameOptions < Base
      ##
      # This patched version of #call will
      # just act as a NOOP Passthru.
      # Nothing is actually done.
      def call(env)
        status, headers, body = @app.call(env)
        [status, headers, body]
      end
    end
  end
end
