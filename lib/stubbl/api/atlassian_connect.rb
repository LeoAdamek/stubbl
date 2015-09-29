class Stubbl::API::AtlassianConnect < Sinatra::Base
  get '/atlassian-connect.json' do
    content_type 'application/json'

    @app_descriptor = YAML.load_file File.join( File.dirname(__FILE__), 'atlassian_connect.yaml')
    @app_descriptor.to_json
  end
end
