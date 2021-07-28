#!/bin/ruby
# frozen_string_literal: true

class SVGExtension < Rule
  def self.initiate
    @desc = 'SVG Extension'
  end

  def self.evaluate(url)
    url.uri.path.end_with? '.svg'
  end
end
