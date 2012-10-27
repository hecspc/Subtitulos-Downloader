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

    it 'should fetch italian language' do
      episode = SubtitulosDownloader::ShowEpisode.new('fringe', 3, 7)
      subtitle = @provider.fetch(episode, 'italian')
      subtitle.language.should == 'italian'
      subtitle.show_episode.should == episode
      subs = (subtitle.subtitles =~ /Quello che conta e' che sono nei guai./) > 1
      subs.should == true
    end

    it 'should fetch second español if first is not completed' do
      episode = SubtitulosDownloader::ShowEpisode.new('Hustle', 7, 3)
      subtitle = @provider.fetch(episode, 'es')
      subtitle.language.should == 'es'
      subtitle.show_episode.should == episode
      subs = (subtitle.subtitles =~ /el reverendo R.G. Wendell/) > 1
    end
  end

  context "Rasing Exceptions" do 
    before(:all) do
      @provider = SubtitulosDownloader::SubtitulosEs.new()
    end

    it 'should raise a not show found exception' do
      episode = SubtitulosDownloader::ShowEpisode.new('fake show', 2, 4)
      lambda{@provider.fetch(episode, 'es')}.should raise_error(SubtitulosDownloader::ShowNotFound)
    end

    it 'should raise more than one show exception' do
      episode = SubtitulosDownloader::ShowEpisode.new('the', 3, 4)
      lambda{@provider.fetch(episode, 'es')}.should raise_error(SubtitulosDownloader::MoreThanOneShow)
    end

    it 'should raise season not found exception' do
      episode = SubtitulosDownloader::ShowEpisode.new('the simpsons', 3, 4)
      lambda{@provider.fetch(episode, 'es')}.should raise_error(SubtitulosDownloader::SeasonNotFound)
    end

    it 'should raise episode not found exception' do
      episode = SubtitulosDownloader::ShowEpisode.new('the simpsons', 22, 34)
      lambda{@provider.fetch(episode, 'es')}.should raise_error(SubtitulosDownloader::EpisodeNotFound)
    end

    it 'should raise episode not translated exception' do
      episode = SubtitulosDownloader::ShowEpisode.new('the simpsons', 20, 1)
      lambda{@provider.fetch(episode, 'galego')}.should raise_error(SubtitulosDownloader::TranslationNotFinished)
    end

     it 'should raise language not found exception' do
      episode = SubtitulosDownloader::ShowEpisode.new('the simpsons', 20, 1)
      lambda{@provider.fetch(episode, 'esperanto')}.should raise_error(SubtitulosDownloader::LanguageNotFound)
    end


  end
end