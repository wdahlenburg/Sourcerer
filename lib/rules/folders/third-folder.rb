#!/bin/ruby
# frozen_string_literal: true

class ThirdFolder < Rule
  def self.initiate
    @desc = 'Only returns if this is the third folder'
  end

  def self.evaluate(url)
    url.dir? and url.n_dirs == 3
  end
end
