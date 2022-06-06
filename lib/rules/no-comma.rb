#!/bin/ruby
# frozen_string_literal: true

class NoComma < Rule
  def self.initiate
    @desc = 'Ensures there are no commas in the entire url'
  end

  def self.evaluate(url)
    return !url.path.include?(',')
  end
end
