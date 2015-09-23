# coding: utf-8

module Stubbl
  module CLI
    class App < Thor

      desc 'issue [🔑]', 'Generate the stub for issue 🔑'
      option :print, type: :boolean
      map 'i' => :issue
      def issue(issue_key)

        jira = Stubbl::JIRA.new

        issue = jira.issue issue_key

        if issue.nil?
          STDERR.puts "Issue #{issue_key} not found."
          exit 1
        end
        
        # Output the PDF to STDOUT so we can pipe it 😁
        stub = (Stubbl::Generator.issue issue).render

        options[:print] ? Stubbl::Generator.print(stub) : puts(stub)
      end


      desc 'issues [key]...', 'Generate stubs for each issue KEY'
      option :print, type: :boolean
      def issues(*issue_keys)

        issues = jira.issues issue_keys

        if issues.empty?
          STDERR.puts "None of the specified issues were found"
        end
        
        stub = (Stubbl::Generator.issues issues).render

        options[:print] ? Stubbl::Generator.print(stub) : puts(stub)
      end

      desc 'search [query]', 'Generate stubs for issues matching the jql QUERY'
      map 's' => :search
      option :print, type: :boolean
      def search(*query)
        j = Stubbl::JIRA.new

        issues = j.search(query.join(' '))

        if issues.nil?
          STDERR.puts "No Issues matching your search"
          exit 1
        end

        stub = (Stubbl::Generator.issues issues).render

        options[:print] ? Stubbl::Generator.print(stub) : puts(stub)
      end
    end
  end
end

require 'stubbl/lib/jira'
Stubbl.load_generator
