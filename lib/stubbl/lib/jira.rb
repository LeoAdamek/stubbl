# coding: utf-8
module Stubbl
  ##
  # JIRA Client Class
  #
  # Used to make API requets to JIRA.
  class JIRA
    include HTTParty
    include ERB::Util

    ##
    # Initialize A JIRA CLient
    #
    # It is recommended that you create a user specifically for
    # api integration, to avoid storing your password in plaintext
    # and to also have specific permissions control.
    #
    # @param [String] jira_uri JIRA Site base URI
    # @param [String] username JIRA Username
    # @param [String] password JIRA Password
    #
    def initialize(jira_uri = ENV['JIRA_URL'], username = ENV['JIRA_USER'], password = ENV['JIRA_PASS'])
      self.class.basic_auth( username, password )
      self.class.base_uri (jira_uri + '/rest/api/2/')
    end


    ##
    # Get Issue
    #
    # @param [String] issue_key Issue Key
    #
    # @return [Stubbl::JIRAIssue] Issue Data
    def issue(issue_key)
      JIRAIssue.new (self.class.get "/issue/#{issue_key}")
    end

    ##
    # Search for issues
    #
    # @param [String] query JQL Query
    #
    # @return [Array[Stubbl::JIRAIssue]] Matching issues
    def search(query)
      issues = self.class.get('/search/?jql=' + url_encode(query))["issues"]

      if issues.nil?
        return []
      end
      
      issues.collect do |issue|
        JIRAIssue.new issue
      end
    end
    
  end
end

require 'stubbl/lib/jira_issue'
require 'erb'

