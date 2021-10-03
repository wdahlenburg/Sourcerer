#!/bin/ruby
# frozen_string_literal: true

class PDFExtension < Rule
  def self.initiate
    @desc = 'PDF Extension'
  end

  def self.evaluate(url)
    url.uri.path.downcase.end_with? '.pdf'
  end
end
