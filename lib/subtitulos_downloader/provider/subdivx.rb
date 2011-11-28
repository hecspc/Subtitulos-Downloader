# encoding: utf-8
require 'hpricot'

module SubtitulosDownloader
  
  # source: https://github.com/rha7dotcom/subdivx/blob/master/subdivx.rb.disabled
  class Subdivx < Provider

    def init
      @base_uri = "http://www.subdivx.com"
      @provider_name = "subdivx"  
    end

    def fetch(show_episode, language)

    end

  end

end