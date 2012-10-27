require 'tvdb'

module SubtitulosDownloader

  class ShowEpisode < Video

    attr_accessor :show_name, :season, :episode, :episode_name
    

    def initialize(show_name, season, episode, options = {})
      
      @name = show_name
      @show_name = @name
      @season = season.to_i
      @episode = episode.to_i
      @options = options
      @subtitles = []

      if @options[:tvdb_api_key]
        fetch_data_from_tvdb(@options[:tvdb_api_key])
      end
    end

    def fetch_data_from_tvdb(key)
      @tvdb = TVdb::Client.new(key)  
      tvdb_show = @tvdb.search(@show_name)
      if tvdb_show.count > 0
        tvdb_show = tvdb_show[0]
        @name = tvdb_show.seriesname
        tvdb_show.episodes.each do |ep|
          ep_number = ep.episodenumber
          ep_season = ep.combined_season
          if ep_number.to_i == @episode && ep_season.to_i == @season
            @episode_name = ep.episodename
            break
          end
        end
      else
        raise ShowNotFound, "[TVdb] show #{@name} not found"
      end
    end

    

    def full_name
      episode_str = "%02d" % @episode
      if @episode_name
        "#{@name} - #{@season}x#{episode_str} - #{@episode_name}"
      else
        "#{@name} - #{@season}x#{episode_str}"
      end
    end

    def show_path
      safe_file_name "#{@name}"
    end

    def season_path
      "#{self.show_path}/Season #{@season}"
    end

    def full_path
      "#{self.season_path}/#{safe_file_name self.full_name}"
    end

    def episode_path
      self.full_path
    end

    def self.new_from_file_name(file_name, options={})
      # House.S04E13.HDTV.XviD-XOR.avi
      # my.name.is.earl.s03e07-e08.hdtv.xvid-xor.[VTV].avi
      # My_Name_Is_Earl.3x17.No_Heads_And_A_Duffel_Bag.HDTV_XviD-FoV.[VTV].avi
      # My Name Is Earl - 3x04.avi
      # MythBusters - S04E01 - Newspaper Crossbow.avi
      # my.name.is.earl.305.hdtv-lol.[VTV].avi
      
      # TODO look up the regex used in XBMC to get data from TV episodes
      re =
        /^(.*?)(?:\s?[-\.]\s?)?\s*\[?s?(?:
        (?:
          (\d{1,2})
          \s?\.?\s?[ex-]\s?
          (?:(\d{2})(?:\s?[,-]\s?[ex]?(\d{2}))?)
        )
        |
        (?:
          \.(\d{1})(\d{2})(?!\d)
        )
        )\]?\s?.*$/ix
      
      if match = file_name.to_s.match(re)
        series  = match[1].gsub(/[\._]/, ' ').strip.gsub(/\b\w/){$&.upcase}
        season  = (match[2] || match[5]).to_i
        episode = (match[3] || match[6]).to_i
        episode = (episode)..(match[4].to_i) unless match[4].nil?
        
        show_episode = ShowEpisode.new(series, season, episode, options) 
      else
        nil
      end
      
    end


  end

end