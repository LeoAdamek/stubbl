module Stubbl::API
  module Actions
    class Stubs < Sinatra::Base
      get '/actions/stubs' do
        erb :stubs
      end
    end
  end
end

