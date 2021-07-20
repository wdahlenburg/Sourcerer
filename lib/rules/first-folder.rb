#!/bin/ruby
# frozen_string_literal: true

class FirstFolder < Rule
  def self.initiate
    @desc = 'Only returns if this is a single folder path'
  end

  def self.evaluate(url)
    url.dir? and url.n_dirs == 1
  end
end
