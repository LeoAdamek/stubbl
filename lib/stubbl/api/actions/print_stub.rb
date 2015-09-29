module Stubbl::API
  module Actions
    class PrintStub < Sinatra::Base
      get '/actions/print-stub/:issue_key' do
        Stubbl.load_generator
        require 'stubbl/lib/jira'
        j = Stubbl::JIRA.new
        Stubbl::Generator.print (Stubbl::Generator.issue j.issue(params[:issue_key])).render
      end
    end
  end
end
