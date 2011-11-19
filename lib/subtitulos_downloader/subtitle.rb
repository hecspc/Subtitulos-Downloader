module SubtitulosDownloader

  class Subtitle

    attr_accessor :subtitles, :language, :show_episode

    def initialize(subs, language, show_episode)
      @subtitles = subs
      @language = language
      @show_episode = show_episode
      @show_episode.subtitles << self
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