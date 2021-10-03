#!/bin/ruby
# frozen_string_literal: true

class EOTExtension < Rule
  def self.initiate
    @desc = 'EOT Extension'
  end

  def self.evaluate(url)
    url.uri.path.downcase.end_with? '.eot'
  end
end
