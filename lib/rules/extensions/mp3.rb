#!/bin/ruby
# frozen_string_literal: true

class MP3Extension < Rule
  def self.initiate
    @desc = 'MP3 Extension'
  end

  def self.evaluate(url)
    url.uri.path.downcase.end_with? '.mp3'
  end
end
