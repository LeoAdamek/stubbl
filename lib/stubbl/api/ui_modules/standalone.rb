module Stubbl::API
  module UIModules
    class Standalone < Sinatra::Base
      get '/' do
        erb :standalone
      end

      post '/print' do
        Stubbl.load_generator
        require 'stubbl/lib/jira'
        j = Stubbl::JIRA.new
        Stubbl::Generator.print (Stubbl::Generator.issue j.issue(params[:issue_key])).render
      end
    end
  end
end
