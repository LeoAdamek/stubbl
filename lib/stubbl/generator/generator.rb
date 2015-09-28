# coding: utf-8
module Stubbl
  class Generator

    require 'prawn/measurement_extensions'
    
    PAGE_OPTIONS = {
      page_size: [52.mm, 70.mm],
      page_layout: :landscape,
      margin: [2.mm,2.mm,2.mm,7.mm]
    }

    PAGE_FONT = 'Courier'
    
    class << self

      ##
      # Print the given stub
      #
      # @param [String] content Stub content
      def print(content)
        f = Tempfile.new('stub')
        f.write(content)
        f.rewind
        
        `lpr -P#{Stubbl::PRINTER_NAME} < #{f.path}`

        f.unlink
        f.close
      end
      
      ##
      # Generate the stub for a single issue
      #
      # @param [Stubbl::JIRAIssue] issue JIRA Issue
      def issue(issue)
        
        doc = Prawn::Document.new PAGE_OPTIONS
        doc.font PAGE_FONT
        
        page_for_issue( doc, issue )

        doc
      end

      ##
      # Generate the stubs for multiple issues
      #
      # @param [Array[Stubbl::JIRAIssue]] issues JIRA Issues
      def issues(issues)

        doc = Prawn::Document.new PAGE_OPTIONS
        doc.font PAGE_FONT

        issues.each do |issue|
          page_for_issue(doc, issue)
          doc.start_new_page
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
                      at: [10.mm , 42.mm],
                      size: 24

        # Add the type
        doc.fill_color('000000')
        doc.rectangle [0, 50.mm],
                      10.mm,
                      10.mm

        doc.text_box issue.fields.issuetype.name[0],
                     size: 10.mm,
                     width: 10.mm,
                     height: 10.mm,
                     at: [0,48.mm]
                
        # Draw the top-line
        doc.horizontal_line (-4).mm, 53.mm, at: 44.mm
        # Add the summary
        doc.text_box issue.fields.summary,
                     size: 12,
                     width: 40.mm,
                     height: 25.mm,
                     overflow: :shrink_to_fit,
                     at: [0, 36.mm]

        # Add the creation date so we know if the issue is stale.
        doc.draw_text (Time.parse issue.fields.created).strftime('%d/%m/%y'),
                      at: [0, 1],
                      size: 12

        # Add the priority
        doc.draw_text issue.fields.priority.name,
                      at: [0, 14],
                      size: 12

        # Add the reporter
        doc.draw_text issue.fields.reporter.displayName,
                      at: [0, 28],
                      size: 12
        
        # Add a QR code which links to the issue
        # FIXME: I don't show up on the output PDF.
        qrcode = RQRCode::QRCode.new(issue.short_url)

        doc.svg qrcode.as_svg,
                at: [40.mm, 20.mm],
                width: 20.mm

      end
    end
  end
end

require 'prawn/measurement_extensions'
