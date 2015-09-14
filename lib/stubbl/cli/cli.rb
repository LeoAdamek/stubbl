# coding: utf-8

module Stubbl
  module CLI
    class App < Thor

      desc 'issue [🔑]', 'Generate the stub for issue 🔑'
      map 'i' => :issue
      def issue(issue_key)
        # Output the PDF to STDOUT so we can pipe it 😁
        puts (Stubbl::Generator.issue issue_key).render
      end


      desc 'issues [key]...', 'Generate stubs for each issue KEY'
      def issues(*issue_keys)


        puts (Stubbl::Generator.issues issue_keys).render
       
      end

      desc 'search [query]', 'Generate stubs for issues matching the jql QUERY'
      map 's' => :search
      def search(*query)
        j = Stubbl::JIRA.new

        j.search(query.join(' ')).each { |i| puts i[:key] }
      end
    end
  end
end

require 'stubbl/lib/jira'
Stubbl.load_generator
