# coding: utf-8
module Stubbl
  class Generator
    class << self

      ##
      # Generate the stub for a single issue
      #
      # @param [Stubbl::JIRAIssue] issue JIRA Issue
      def issue(issue)
        doc = Prawn::Document.new(
          page_size: [19.mm, 53.mm],
          page_layout: :landscape,
          margin: 2.mm
        )

        page_for_issue( doc, issue )

        doc
      end

      ##
      # Generate the stubs for multiple issues
      #
      # @param [Array[Stubbl::JIRAIssue]] issues JIRA Issues
      def issues(issues)
        doc = Prawn::Document.new(
          page_size: [19.mm, 53.mm],
          page_layout: :landscape,
          margin: (1.5).mm
        )

        issues.each do |issue|
          doc.start_new_page
          page_for_issue(doc, issue)
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
                      at: [5.mm, 12.mm],
                      size: 4.mm

        # Add the type
        doc.draw_text issue.fields.issuetype.name[0].upcase,
                      at: [0, 12.mm],
                      size: 5.mm
        
        # Draw the top-line
        doc.horizontal_line (-2).mm, 53.mm, at: 12.mm
        
        # Add the summary
        doc.draw_text issue.fields.summary,
                      at: [0, 8.mm],
                      size: 2.mm

        # Add the creation date so we know if the issue is stale.
        doc.draw_text (Time.parse issue.fields.created).strftime('%d/%m/%y'),
                      at: [0, (0.5).mm],
                      size: (2.5).mm
        
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
