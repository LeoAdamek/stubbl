# coding: utf-8

module Stubbl
  module CLI
    class App < Thor

      desc 'issue [🔑]', 'Generate the stub for issue 🔑'
      option :print, type: :boolean
      map 'i' => :issue
      def issue(issue_key)
        # Output the PDF to STDOUT so we can pipe it 😁
        stub = (Stubbl::Generator.issue issue_key).render

        options[:print] ? Stubbl::Generator.print(stub) : puts(stub)
      end


      desc 'issues [key]...', 'Generate stubs for each issue KEY'
      option :print, type: :boolean
      def issues(*issue_keys)
        stub = (Stubbl::Generator.issues issue_keys).render

        options[:print] ? Stubbl::Generator.print(stub) : puts(stub)
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
