module SubtitulosDownloader

  class Subtitle

    attr_accessor :subtitles, :language, :video

    def initialize(subs, language, video)
      @subtitles = subs
      @language = language
      @video = video
      @video.subtitles << self
    end


    def save_path
      "#{@video.full_path}.#{@language}.srt"
    end

  end

end