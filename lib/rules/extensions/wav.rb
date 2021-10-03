#!/bin/ruby
# frozen_string_literal: true

class WAVExtension < Rule
  def self.initiate
    @desc = 'WAV Extension'
  end

  def self.evaluate(url)
    url.uri.path.downcase.end_with? '.wav'
  end
end
