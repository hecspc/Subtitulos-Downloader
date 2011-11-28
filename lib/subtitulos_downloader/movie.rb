module SubtitulosDownloader
  class Movie < Video

    attr_accessor :year

    def initialize(movie_name, year, options = {})

      @name = movie_name
      @year = year

      @subtitles = []

  end

  def full_name
    "#{@name} (#{@year})"
  end

  def self.new_from_file_name(file_name, options = {})

  end

  def full_path
    "#{@name}/#{self.full_name}"
  end


end