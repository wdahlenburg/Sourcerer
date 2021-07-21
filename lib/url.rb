#!/bin/ruby
# frozen_string_literal: true

require 'uri'

# Helper url functions
class Url
  def initialize(url)
    @uri = URI(url)
    @path = @uri.path
    @url = url
  end

  def dir?
    @path.end_with?('/')
  end

  def file?
    !dir?
  end

  def n_dirs
    @path.count('/') - 1
  end

  def get_sub_folder_urls
    base_url = get_url(@uri, '/')
    urls = []
    if file?
      path = @path

      i = @path.length
      while path != ''
        path_rev = path.reverse
        i = path_rev.index('/')
        new_path = path_rev.slice(i, path.length).reverse
        t_url = get_url(@uri, new_path)

        urls << t_url if !urls.include?(t_url) && (t_url != base_url)
        path = new_path.slice(0, new_path.length - 1)
      end
    end
    urls
  end

  def get_url(uri, new_path)
    if (uri.port == 443) || (uri.port == 80)
      "#{uri.scheme}://#{uri.hostname}#{new_path}"
    else
      "#{uri.scheme}://#{uri.hostname}:#{uri.port}#{new_path}"
    end
  end
end
