#!/bin/ruby
# frozen_string_literal: true

class SVGExtension < Rule
  def self.initiate
    @desc = 'SVG Extension'
  end

  def self.evaluate(url)
    url.uri.path.downcase.end_with? '.svg'
  end
end
