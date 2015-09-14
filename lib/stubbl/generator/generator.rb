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
          page_size: [53.mm, 75.mm],
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
          page_size: [53.mm, 75.mm],
          page_layout: :landscape,
          margin: 2.mm
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
                      at: [15.mm , 40.mm],
                      size: 24

        # Add the type
        unless issue.icon.nil?
          doc.image issue.icon,
                  at: [0, 48.mm],
                  width: 10.mm,
                  height: 10.mm
        end
        
        # Draw the top-line
        doc.horizontal_line (-2).mm, 53.mm, at: 48.mm
        
        # Add the summary
        doc.move_down 12.mm
        doc.text issue.fields.summary,
                      size: 12

        # Add the creation date so we know if the issue is stale.
        doc.draw_text (Time.parse issue.fields.created).strftime('%d/%m/%y'),
                      at: [0, 1],
                      size: 14
        
        # Add a QR code which links to the issue
        # FIXME: I don't show up on the output PDF.
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
