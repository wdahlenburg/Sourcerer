#!/bin/ruby
# frozen_string_literal: true

# Generic class to define rules
class Rule
  def self.initialize
    @desc = 'Generic Rule'
  end

  def self.evaluate(_url)
    raise StandardError, 'Not implemented!'
  end
end
