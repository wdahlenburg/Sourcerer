#!/bin/ruby
# frozen_string_literal: true

class WAVExtension < Rule
  def self.initiate
    @desc = 'WAV Extension'
  end

  def self.evaluate(url)
    url.uri.path.end_with? '.wav'
  end
end
