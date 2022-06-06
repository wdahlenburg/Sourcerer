#!/bin/ruby
# frozen_string_literal: true

class QueryString < Rule
  def self.initiate
    @desc = 'Only returns urls with query strings'
  end

  def self.evaluate(url)
    !url.uri.query.nil? && !url.uri.query.empty?
  end
end
