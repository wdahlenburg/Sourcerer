#!/bin/ruby
# frozen_string_literal: true

require 'uri'

# Helper url functions
class Url
  def initialize(url)
    uri = URI(url)
    @path = uri.path
    @url = url
  end

  def dir?
    @path.end_with?('/')
  end

  def file?
    !isDir?
  end

  def n_dirs
    @path.count('/') - 1
  end
end
