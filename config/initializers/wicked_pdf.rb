class WickedPdf
  # Wicked Pdf magic breaks ViewComponent
  # https://github.com/mileszs/wicked_pdf/pull/925
  module PdfHelper
    def render(*args)
      options = args.first
      if options.is_a?(Hash) && options.key?(:pdf)
        render_with_wicked_pdf(options)
      else
        super
      end
    end

    def render_to_string(*args)
      options = args.first
      if options.is_a?(Hash) && options.key?(:pdf)
        render_to_string_with_wicked_pdf(options)
      else
        super
      end
    end
  end
end

# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md

WickedPdf.config = {
  # Path to the wkhtmltopdf executable: This usually isn't needed if using
  # one of the wkhtmltopdf-binary family of gems.
  # exe_path: '/usr/local/bin/wkhtmltopdf',
  #   or
  # exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')

  # Layout file to be used for all PDFs
  # (but can be overridden in `render :pdf` calls)
  # layout: 'pdf.html',
  enable_local_file_access: true
}

unless Rails.env.test? || Rails.env.development?
  WickedPdf.config = {
    exe_path: Gem.bin_path("wkhtmltopdf-binary", "wkhtmltopdf")
  }
end
