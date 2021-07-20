#!/bin/ruby
# frozen_string_literal: true

require 'json'

module Dirsearch
  def self.parse_input(line)
    urls = []

    JSON.parse(line).each do |data|
      urls << data['Url']
    end

    urls
  end
end
