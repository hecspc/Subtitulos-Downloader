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
      "#{@show_episode.episode_path}-#{@language}.srt"
    end

  end

end