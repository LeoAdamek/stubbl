module Stubbl
  class Generator
    class << self

      ##
      # Generate the stub for an issue
      #
      # @param [Stubbl::JIRAIssue] issue JIRA Issue
      def generate(issue)
        p issue.self
      end
    end
  end
end
