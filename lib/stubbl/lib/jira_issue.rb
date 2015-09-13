module Stubbl
  class JIRAIssue < Hashie::Mash
    
      ##
      # Get the icon file for this issue's type
      #
      # @return [String] icon file path
      def icon
        s = fields.issuetype.name.downcase.gsub(/\W+/, '-')
        sp = File.expand_path(File.dirname(__FILE__) + '/../icons/' + s + '.png')

        return sp if File.exists? sp
        nil
      end
  end
end
