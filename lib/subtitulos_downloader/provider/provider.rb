require 'version'

module SubtitulosDownloader
  class Provider

    def initialize(options={})
      @options = options
      @user_agent = "SubtitulosDownloader/#{VERSION}"
      init
    end

    def init(options)
      # to be override
      @base_uri = ""
      @provider_name =''
    end

    def fetch(show, language)

    end

  end
end