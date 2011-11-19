module SubtitulosDownloader
  class Provider

    def initialize(options)
      @options = options
      @base_uri = ""
      @user_agent = "SubtitulosDownloader #{VERSION}/Ruby/#{RUBY_VESION}"
      @provider_name =''
    end

    def fetch(show, language)

    end

  end
end