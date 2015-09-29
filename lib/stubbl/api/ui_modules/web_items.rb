module Stubbl::API::UIModules
  class WebItems < Sinatra::Base
    get '/ui-modules/make-stub' do
      erb :make_stub
    end
  end
end
