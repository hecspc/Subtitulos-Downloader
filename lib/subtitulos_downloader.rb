require "subtitulos_downloader/version"
require "subtitulos_downloader/subtitle"
require "subtitulos_downloader/show_episode"
require "subtitulos_downloader/exception"
require "subtitulos_downloader/provider/provider"
Dir["#{File.dirname(__FILE__)}/subtitulos_downloader/provider/*.rb"].each {|f| require f}
require "subtitulos_downloader/notifier/notifier"
Dir["#{File.dirname(__FILE__)}/subtitulos_downloader/notifier/*.rb"].each {|f| require f}

module SubtitulosDownloader

  class SubtitulosDownloader
    def initialize(opts = {})
      options = {
        :provider => SubtitulosEs,
        :tvdb_api_key => 'EF41E54C744526F7'
      }.merge!(opts)
      
      @provider = options[:provider].new(options)
      @options = options
    end

    def fetch(show_name, season, episode, languages = %w[ es en ])
      languages = [languages] if not languages.respond_to?('each')
      show_episode = ShowEpisode.new(show_name, season, episode, @options)
      languages.each do |language|
        @provider.fetch(show_episode, language)
      end
      show_episode
    end

    def fetch_by_file_name(file_name, languages = %w[ es en ])
      languages = [languages] if not languages.respond_to?('each')
      show_episode = ShowEpisode.new_from_file_name(file_name, @options)
      languages.each do |language|
        @provider.fetch(show_episode, language)
      end
      show_episode
    end

    def fetch_by_show_episode(show_episode, languages = %w[ es en ])
      languages = [languages] if not languages.respond_to?('each')
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
