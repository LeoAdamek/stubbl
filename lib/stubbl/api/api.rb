# coding: utf-8

module Stubbl::API; end

require 'sinatra'
require 'stubbl/api/atlassian_connect'
require 'stubbl/api/actions/print_stub'
require 'stubbl/api/actions/stubs'
require 'stubbl/api/ui_modules/standalone'

class Stubbl::API::App < Sinatra::Base

  set :sessions, true
  enable :logging

  use Stubbl::API::AtlassianConnect
  use Stubbl::API::Actions::PrintStub
  use Stubbl::API::Actions::Stubs
  use Stubbl::API::UIModules::Standalone
  
  # Run the app if it was started directly
  run! if app_file == $0
end

