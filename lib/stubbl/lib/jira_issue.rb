# coding: utf-8
module Stubbl
  class JIRAIssue < Hashie::Mash

    ##
    # Font-awesome mapping for Icons
    ISSUE_TYPE_ICONS = {
      issue: ["F188".hex].pack("U"),       # fa-bug
      question: ["F059".hex].pack("U"),    # fa-question-circle
      new_feature: ["F055".hex].pack("U"), # fa-plus-circle
      story: ["F02D".hex].pack("U"),       # fa-book
      epic: ["F0E7".hex].pack("U"),        # fa-bolt
      task: ["F0AE".hex].pack("U")         # fa-tasks
    }.freeze
    
    ##
    # Get the icon file for this issue's type
    #
    # @return [String] icon file path
    def icon
      begin
        s = fields.issuetype.name.downcase.gsub(/\W+/, '_')
        puts s.to_sym
        puts ISSUE_TYPE_ICONS[s.to_sym]
        return ISSUE_TYPE_ICONS[s.to_sym]
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
