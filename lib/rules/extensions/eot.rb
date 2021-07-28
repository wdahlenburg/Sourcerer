#!/bin/ruby
# frozen_string_literal: true

class EOTExtension < Rule
  def self.initiate
    @desc = 'EOT Extension'
  end

  def self.evaluate(url)
    url.uri.path.end_with? '.eot'
  end
end
