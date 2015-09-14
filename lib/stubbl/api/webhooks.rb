module Stubbl
  module API
    class Webhooks < Grape::API

      desc 'Get the Atlassian Connect description'
      get '/atlassian-connect' do
        {
          name: 'Stubbl',
          description: 'Ticket stubs have never been this good.',
          baseUrl: 'https://3ebe5e4b.ngrok.com/',
          key: 'com.mrzen.stubbl',
          vendor: {
            name: 'Mr. Zen, Ltd.',
            url: 'http://mrzen.com'
          },

          authentication: {
            type: 'none'
          },

          version: '0.1'
        }
      end
      
    end
  end
end
