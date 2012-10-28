# encoding: utf-8
require 'nokogiri'
require 'uri'
require 'net/http'
require 'ensure/encoding'

module SubtitulosDownloader

  class SubtitulosEs < Provider

    def init
      @base_uri = "http://www.subtitulos.es"
      @provider_name = "subtitulos.es"  
    end
    

    def fetch(show_episode, language)

      get_shows_page unless @shows_doc

      shows = search_show show_episode
      
      show_sub = shows.first

      episode_subs_table = get_episode_table show_episode, show_sub
      
      case language
        when 'en'
          lang = 'English'
        when 'es'
          lang = 'España'
        else
          lang = language
      end

      begin
        subs = get_subtitles(lang, episode_subs_table, show_sub)
        translators = get_translators(show_sub)
        subtitle = Subtitle.new subs, language, show_episode, @translators, @direct_link, @provider_link, @provider_name, @provider_language
      rescue SDException => e
        if language == 'es'
          if lang == 'España' 
            lang = 'Latinoamérica'
            retry
          elsif lang == 'Latinoamérica'
            lang = 'Español'
            retry
          else
            raise e
          end
        else
          raise e
        end        
      end

      subtitle

    end

    protected

    def get_translators(show_sub)
      ep_doc = Nokogiri::HTML(open(@provider_link,
        "User-Agent" => @user_agent,
        "Referer" => "#{@base_uri}/show/#{show_sub[:id_show]}" ), nil, 'UTF-8')
      ep_doc.encoding = 'utf-8'
      split = @direct_link.split('/')
      sub_id = [split.pop, split.pop].reverse.join('/')
      ep_doc.css('span.descargar').each do |green|
        a = green.css('a').first
        if a and a['href'] == @direct_link 
          translated = green.xpath('following-sibling::span')[2]
          @translators = translated.css('a').count
          return @translators
        end
        # title = (episode_table/"tr/td[@colspan='5']/a").inner_html
        # episode_str = "%02d" % show_episode.episode
        # episode_number = "#{show_episode.season}x#{episode_str}"
        # if title =~ /#{episode_number}/i
        #   ep_t = episode_table
        #   break
        # end
      end
      @translators = -1
    end

    def get_subtitles(language, episode_table, show_sub)
      @provider_link = episode_table.css("td.NewsTitle a").first['href']
      
      translation_unfinished = false
      episode_table.css("tr td.language").each do |lang|
        language_sub = lang.text.strip
        if language_sub =~ /#{language}/i
          # puts "Language #{language} found #{language_sub}"  
          completed = lang.parent.css('td:nth-child(6)')
          if not completed.text.strip =~ /[0-9]+\.?[0-9]*% Completado/i
            # puts "Translation for language #{language} completed"
            subtitle_a = lang.parent.css("a").first
            subtitle_url = subtitle_a['href']
            # puts "Fetching #{language} subtitle file"
            @provider_language = language_sub
            @direct_link = subtitle_url
            # @provider_link = "#{@base_uri}/show/#{show_sub[:id_show]}"
            translation_unfinished = false 

            uri = URI.parse subtitle_url
            http = Net::HTTP.new(uri.host, uri.port)
            req = Net::HTTP::Get.new(uri.path, {"User-Agent" => @user_agent, "Referer" => "#{@base_uri}/show/#{show_sub[:id_show]}"})
            response = http.request(req)
            utf8_body = response.body.ensure_encoding('UTF-8', :external_encoding => 'ISO-8859-1', :invalid_characters => :transcode)
            
            return utf8_body
            
          else
            translation_unfinished = true              
          end
        end
      end
      if translation_unfinished
        raise TranslationNotFinished, "[#{@provider_name}] #{language} translation not finished for #{show_sub[:show_episode].full_name}" 
      else
        raise LanguageNotFound, "[#{@provider_name}] #{language} not found for #{show_sub[:show_episode].full_name}"
      end
    end


    def search_show show_episode
      shows = []
      old_name = show_episode.show_name
      show_episode.show_name = 'Louie' if show_episode.show_name == 'Louie (2010)'
      show_episode.show_name = 'Castle' if show_episode.show_name == 'Castle (2009)'
      show_episode.show_name = 'The Newsroom' if show_episode.show_name == 'The Newsroom (2012)'
      show_episode.show_name = 'The Office' if show_episode.show_name == 'The Office (US)' or show_episode.show_name == 'The Office (1995)'
      show_episode.show_name = 'Spartacus: Blood and Sand' if show_episode.show_name =~ /Spartacus/i	
      @shows_doc.css("#contenido a").each do |show_subs|
        show_name = show_subs.text
        show_url = show_subs['href']
        show = { :show_episode => show_episode, :url => show_url, :id_show => show_url.split('/show/')[1].to_i }
        if (show_name == show_episode.show_name)
          shows = []
          shows << show
          break
        elsif show_name =~ /^#{show_episode.show_name}/i and (show_name != 'Scrubs Interns' and show_name != 'true blood minisodes')
          shows << show
        end
      end
      raise ShowNotFound, "[#{@provider_name}] #{show_episode.show_name} not found" if shows.count == 0
      raise MoreThanOneShow, "[#{@provider_name}] Found #{shows.count} for #{show_episode.show_name}" if shows.count > 1
      old_name = 'The Office (US)' if old_name == 'The Office (1995)'
      show_episode.show_name = old_name
      shows
    end

    def get_episode_table(show_episode, show_sub)

      season_url = "#{@base_uri}/ajax_loadShow.php?show=#{show_sub[:id_show]}&season=#{show_episode.season}"
      ep_t = nil
      season_doc = Nokogiri::HTML(open(season_url,
        "User-Agent" => @user_agent,
        "Referer" =>"#{@base_uri}" ), nil, 'UTF-8')
      season_doc.encoding = 'utf-8'
      raise SeasonNotFound, "[#{@provider_name}] Season for #{show_episode.full_name} not found" if season_doc.css('table').count == 0

      season_doc.css('table').each do |episode_table|
        title = episode_table.css("tr td[colspan='5'] a").text
        episode_str = "%02d" % show_episode.episode
        episode_number = "#{show_episode.season}x#{episode_str}"
        if title =~ /#{episode_number}/i
          ep_t = episode_table
          break
        end
      end

      if ep_t
        return ep_t
      else
        raise EpisodeNotFound, "[#{@provider_name}] Episode #{show_episode.full_name} not found"
      end

    end


    def get_shows_page
      @shows_doc = Nokogiri::HTML(open(
      "#{@base_uri}/series", 
      "User-Agent" => @user_agent,
      "Referer" =>"#{@base_uri}" ), nil, 'UTF-8')
      @shows_doc.encoding = 'utf-8'
    end

  end

end
