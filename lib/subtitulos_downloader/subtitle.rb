module SubtitulosDownloader

  class Subtitle

    attr_accessor :subtitles, :language, :show_episode, :direct_link, :provider, :provider_link, :provider_language

    def initialize(subs, language, show_episode, direct_link, provider_link, provider, provider_language)
      @subtitles = subs
      @language = language
      @show_episode = show_episode
      @show_episode.subtitles << self
      @provider_link = provider_link
      @direct_link = direct_link
      @provider = provider
      @provider_language = provider_language
    end


    def save_path
      case @language
        when 'es'
          lang = 'Spanish'
        when 'en'
          lang = 'English'
        else
          lang = @language
      end
      "#{@show_episode.episode_path}-#{lang}.srt"
    end

  end

end