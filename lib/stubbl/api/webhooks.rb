module Stubbl
  module API
    class Webhooks < Grape::API

      desc 'Get the Atlassian Connect description'
      get '/atlassian-connect' do
        {
          message: 'Not yet implemented'

        }
      end
      
    end
  end
end
