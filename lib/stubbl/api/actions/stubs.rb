module Stubbl::API
  module Actions
    class Stubs < Sinatra::Base

      disable :protection

      get '/actions/stubs' do
        erb :stubs
      end
    end
  end
end
