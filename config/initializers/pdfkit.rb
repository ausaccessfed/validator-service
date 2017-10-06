# frozen_string_literal: true

PDFKit.configure do |config|
  config.wkhtmltopdf = Bundler.which('wkhtmltopdf')
end
