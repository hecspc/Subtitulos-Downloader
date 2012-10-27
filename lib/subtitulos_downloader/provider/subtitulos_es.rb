# encoding: utf-8
require 'hpricot'

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
        subtitle = Subtitle.new subs, language, show_episode, @direct_link, @provider_link, @provider_name, @provider_language
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

    def get_subtitles(language, episode_table, show_sub)
      @provider_link = (episode_table/"td.NewsTitle/a").first.attributes['href']
      (episode_table/"tr/td.language").each do |lang|
        language_sub = lang.inner_html.strip.force_encoding('utf-8')
        if language_sub =~ /#{language}/i
            # puts "Language #{language} found"
            if not lang.next_sibling.inner_html =~ /[0-9]+\.?[0-9]*% Completado/i
              # puts "Translation for language #{language} completed"
              subtitle_a = lang.parent.search("a").at(0)
              subtitle_url = subtitle_a.attributes['href']
              # puts "Fetching #{language} subtitle file"
              @provider_language = language_sub
              @direct_link = subtitle_url
              # @provider_link = "#{@base_uri}/show/#{show_sub[:id_show]}"
              open(subtitle_url, 
                "User-Agent" => @user_agent,
                "Referer" => "#{@base_uri}/show/#{show_sub[:id_show]}") { |f|
                  # Save the response body
                  subs= f.read
                  return subs
              }
            else
              raise TranslationNotFinished, "[#{@provider_name}] #{language} translation not finished for #{show_sub[:show_episode].full_name}"              
            end
        end
      end
      raise LanguageNotFound, "[#{@provider_name}] #{language} not found for #{show_sub[:show_episode].full_name}"
    end


    def search_show show_episode
      shows = []
      old_name = show_episode.show_name
      show_episode.show_name = 'Louie' if show_episode.show_name == 'Louie (2010)'
      show_episode.show_name = 'Castle' if show_episode.show_name == 'Castle (2009)'
      show_episode.show_name = 'The Newsroom' if show_episode.show_name == 'The Newsroom (2012)'
      show_episode.show_name = 'The Office' if show_episode.show_name == 'The Office (US)' or show_episode.show_name == 'The Office (1995)'
      show_episode.show_name = 'Spartacus: Blood and Sand' if show_episode.show_name =~ /Spartacus/i	
      @shows_doc.search("a").each do |show_subs|
        show_name = show_subs.inner_html.force_encoding('utf-8')
        show_url = show_subs.attributes['href']
        show = { :show_episode => show_episode, :url => show_url, :id_show => show_url.split('/show/')[1].to_i }
        if (show_name == show_episode.show_name)
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
      open(season_url,
        "User-Agent" => @user_agent,
        "Referer" =>"#{@base_uri}" ) { |f|
          
          cont = f.read
          raise SeasonNotFound, "[#{@provider_name}] Season for #{show_episode.full_name} not found" if not cont.match(/<table/)

          season_doc = Hpricot(cont)

          season_doc.search('table').each do |episode_table|
            title = (episode_table/"tr/td[@colspan='5']/a").inner_html.force_encoding('utf-8')
            episode_str = "%02d" % show_episode.episode
            episode_number = "#{show_episode.season}x#{episode_str}"
            if title =~ /#{episode_number}/i
              ep_t = episode_table
              break
            end
          end
      }

      if ep_t
        return ep_t
      else
        raise EpisodeNotFound, "[#{@provider_name}] Episode #{show_episode.full_name} not found"
      end

    end


    def get_shows_page
      open(
      "#{@base_uri}/series", 
      "User-Agent" => @user_agent,
      "Referer" =>"#{@base_uri}" ) { |f|
        @shows_doc = Hpricot(f.read)
      }
    end

  end

end
