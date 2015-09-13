# coding: utf-8
module Stubbl
  class Generator
    class << self

      ##
      # Generate the stub for a single issue
      #
      # @param [String] issue JIRA Issue Key
      def issue(issue_key)
        jira = Stubbl::JIRA.new( ENV['JIRA_URL'], ENV['JIRA_USER'], ENV['JIRA_PASS'] )
        issue = jira.issue issue_key
        
        doc = Prawn::Document.new(
          page_size: [19.mm, 53.mm],
          page_layout: :landscape,
          margin: 2.mm
        )

        doc.font 'Courier'
        
        page_for_issue( doc, issue )

        doc
      end

      ##
      # Generate the stubs for multiple issues
      #
      # @param [Array[String]] issues JIRA Issue Keys
      def issues(issues)

        jira = Stubbl::JIRA.new( ENV['JIRA_URL'], ENV['JIRA_USER'], ENV['JIRA_PASS'] )
        
        doc = Prawn::Document.new(
          page_size: [19.mm, 53.mm],
          page_layout: :landscape,
          margin: 1.mm
        )

        doc.font 'Courier'

        issues.each do |issue|
          doc.start_new_page
          page_for_issue(doc, jira.issue(issue))
        end

        doc
      end


      private
      ##
      # Generate a page for an issue
      #
      # @param [Prawn::Document] doc Document
      # @param [Stubbl::JIRAIssue] issue JIRA Issue for page
      def page_for_issue(doc, issue)

        # Add the issue key
        doc.draw_text issue[:key],
                      at: [5.mm , (12.5).mm],
                      size: 14

        # Add the type
        doc.image issue.icon,
                  at: [0, 16.mm],
                  width: 4.mm,
                  height: 4.mm
        
        # Draw the top-line
        doc.horizontal_line (-2).mm, 53.mm, at: 12.mm
        
        # Add the summary
        doc.move_down 5.mm
        doc.text issue.fields.summary,
                      size: 8

        # Add the creation date so we know if the issue is stale.
        doc.draw_text (Time.parse issue.fields.created).strftime('%d/%m/%y'),
                      at: [0, 1],
                      size: 10
        
        # Add a QR code which links to the issue
        qrcode = RQRCode::QRCode.new(issue.self)

        qrfile = Tempfile.new("issue-#{issue[:key]}-qr")
        qrcode.as_png(
          fill: 'white',
          color: 'black',
          size: 64,
          border_modules: 4,
          module_px_size: 6,
          file: qrfile.path
        )
        
        doc.image qrfile.path, at: [0, 0]

        qrfile.unlink
      end
    end
  end
end

require 'prawn/measurement_extensions'
