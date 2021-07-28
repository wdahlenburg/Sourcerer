#!/bin/ruby
# frozen_string_literal: true

class SecondFolder < Rule
  def self.initiate
    @desc = 'Returns if this is two folders in'
  end

  def self.evaluate(url)
    url.dir? and url.n_dirs == 2
  end
end
