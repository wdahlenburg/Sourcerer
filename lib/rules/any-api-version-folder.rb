#!/bin/ruby
# frozen_string_literal: true

class AnyAPIVersionFolder < Rule
  def self.initiate
    @desc = 'Accept directories matching /v{\d}/ syntax at whatever depth'
  end

  def self.evaluate(url)
    return false unless url.dir?

    folders = url.path.downcase.split('/')
    return folders.any? { |f| !/^v\d{1,3}$/.match(f).nil? }
  end
end
