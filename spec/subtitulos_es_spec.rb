# encoding: utf-8
require 'spec_helper'


describe SubtitulosDownloader::SubtitulosEs do

  context "Fetching subtitles" do
    before(:all) do
      @ep = SubtitulosDownloader::ShowEpisode.new_from_file_name("Fringe.S04E07.HDTV.XviD-LOL.avi.avi")
      @simpsons = SubtitulosDownloader::ShowEpisode.new_from_file_name("The Simpsons - 20x05 - Dangerous Curves")
      @simpsons2 = SubtitulosDownloader::ShowEpisode.new_from_file_name("The Simpsons - 20x07 - Mypods and Boomsticks")
      @provider = SubtitulosDownloader::SubtitulosEs.new()
    end

    it 'should fetch spanish subtitle' do
      subtitle = @provider.fetch(@ep, 'es')
      subtitle.language.should == 'es'
      subtitle.show_episode.should == @ep
      subs = (subtitle.subtitles =~ /Ahora solo tengo que averiguar/) > 1
      subs.should == true
    end

    it 'should fetch english subtitle' do
      subtitle = @provider.fetch(@ep, 'en')
      subtitle.language.should == 'en'
      subtitle.show_episode.should == @ep
      subs = (subtitle.subtitles =~ /10-4. Copy location./) > 1
      subs.should == true
    end

    it 'should fetch latinoamerican instead of spanish subtitles' do
      subtitle = @provider.fetch(@simpsons, 'es')
      subtitle.language.should == 'es'
      subtitle.show_episode.should == @simpsons
      subs = (subtitle.subtitles =~ /Tenemos cubos amarillos, cubos anaranjados/) > 1
      subs.should == true
    end

    it 'should fetch español instead of spanish subtitles' do
      subtitle = @provider.fetch(@simpsons2, 'es')
      subtitle.language.should == 'es'
      subtitle.show_episode.should == @simpsons2
      subs = (subtitle.subtitles =~ /me gusta la forma de pensar de ustedes los italianos/) > 1
      subs.should == true
    end

  end
end