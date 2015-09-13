# coding: utf-8

module Stubbl
  module CLI
    class App < Thor

      desc 'issue [🔑]', 'Generate the stub for issue 🔑'
      map 'i' => :issue
      def issue(issue_key)
        jira = Stubbl::JIRA.new( ENV['JIRA_URL'], ENV['JIRA_USER'], ENV['JIRA_PASS'] )
        issue = jira.issue issue_key

        # Output the PDF to STDOUT so we can pipe it 😁
        puts (Stubbl::Generator.issue issue).render
      end


      desc 'issues [key]...', 'Generate stubs for each issue KEY'
      def issues(*issue_keys)
        jira = Stubbl::JIRA.new( ENV['JIRA_URL'], ENV['JIRA_USER'], ENV['JIRA_PASS'] )

        issues = issue_keys.collect do |key|
          jira.issue key
        end

        puts (Stubbl::Generator.issues issues).render
       
       end
      
    end
  end
end

require 'stubbl/lib/jira'
Stubbl.load_generator
