# coding: utf-8
module Stubbl
  class JIRAIssue < Hashie::Mash
    ##
    # Get the icon file for this issue's type
    #
    # @return [String] icon file path
    def icon
      begin
        s = fields.issuetype.name.downcase.gsub(/\W+/, '_')
        ip = File.expand_path( File.dirname(__FILE__) + '/../icons/' + s + '.png')

        return ip if File.exists? ip

      rescue Exception => e
        STDERR.puts e.message
        return nil
      end
    end
  end
end
