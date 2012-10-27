module SubtitulosDownloader

  class Video 

    attr_accessor :subtitles, :name

    def initialize(name, options = {})
      @subtitles = []
      @name = name
    end

    def subtitle_language(lang)
      subs = nil
      @subtitles.each do |sub|
        if sub.language == lang
          return sub
          break
        end
      end
      return nil
    end

    def full_name

    end

    def self.new_from_file_name(file_name, options = {})

    end

    def full_path
      
    end


    def safe_file_name(file_name)
      return file_name.gsub(/[^\w\.\-\ ]/, '')
    end

  end

end