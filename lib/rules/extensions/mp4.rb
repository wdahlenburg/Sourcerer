#!/bin/ruby
# frozen_string_literal: true

class MP4Extension < Rule
  def self.initiate
    @desc = 'MP4 Extension'
  end

  def self.evaluate(url)
    url.uri.path.end_with? '.mp4'
  end
end
