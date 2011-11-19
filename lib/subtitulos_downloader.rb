require "subtitulos_downloader/version"

module SubtitulosDownloader

  class SubtitulosDownloader
    def initialize(opts)
      options = {
        :provider => SubtitulosDownloader::SubtitulosEs,
        :tvdb_api_key => 'EF41E54C744526F7'
      }.merge!(opts)
      
      @provider = options[:provider].new(options)
      @options = options
    end

    def fetch(show_name, season, episode, languages = %w[ es en ])
      show_episode = ShowEpisode.new(show_name, season, episode, @options)
      languages.each do |language|
        @provider.fetch(show_episode, language)
      end
      show_episode
    end

    def save_subs_to_path(show_episode, path)
      show_episode.subtitles.each do |subtitle|
        check_if_path_exists("#{path}/#{show_episode.show_path}")
        check_if_path_exists("#{path}/#{show_episode.season_path}")
        file = File.new("#{path}/#{subtitle.save_path}", "w")
        file.write(subtitle.subtitles)
        file.close
      end
    end


    protected

    def check_if_path_exists(path)
      if not FileTest::directory?(path)
        Dir::mkdir(path)
      end
    end

  end
end
