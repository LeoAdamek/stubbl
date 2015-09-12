
module Stubbl
  module CLI
    class App < Thor

      desc 'issue [KEY]', 'Generate the stub for issue KEY'
      map 'i' => :issue
      def issue(issue_key)
        jira = Stubbl::JIRA.new( ENV['JIRA_URL'], ENV['JIRA_USER'], ENV['JIRA_PASS'] )
        issue = jira.issue issue_key

        Stubbl::Generator.generate issue
      end
      
    end
  end
end

require 'stubbl/lib/jira'
Stubbl.load_generator
