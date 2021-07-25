#!/bin/ruby
# frozen_string_literal: true

require 'pry'

class APIVersionFolder < Rule
  def self.initiate
    @desc = 'Accept directories matching /v{\d}/ syntax at whatever depth'
  end

  def self.evaluate(url)
    return false unless url.dir?

    final_folder = url.path.split('/')[-1]

    !/^v\d{1,3}$/.match(final_folder).nil?
  end
end
