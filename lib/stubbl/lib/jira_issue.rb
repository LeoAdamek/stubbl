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

    ##
    # Get the full URL to an issue
    #
    # @return [String] URL
    def url
      ENV['JIRA_URL'] + '/browse/' + self[:key]
    end

    ##
    # Get a short url to an issue.
    #
    # Uses bit.ly to shorten urls if it is configured.
    # Otherwise returns full URL.
    #
    # @return [String] Short URL
    def short_url
      if ENV['BITLY_USER'] && ENV['BITLY_API_KEY']
        bitly_short_url
      else
        url
      end
    end


    private
    ##
    # Get the short url via bitly
    def bitly_short_url
      Bitly.use_api_version_3
      bitly = Bitly.new(ENV['BITLY_USER'], ENV['BITLY_API_KEY'])
      bitly.shorten(url, history: 1).jmp_url
    end
  end
end
