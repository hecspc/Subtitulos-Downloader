require 'spec_helper'


describe SubtitulosDownloader::Movie do

  context "Initializing" do

    it 'should create a new movie from a name and a year' do
      movie = SubtitulosDownloader::Movie.new('Star Wars', 1977)
      movie.name.should == 'Star Wars' 
      movie.year.should == 1977
    end

    # it 'should create a new show episode from a file name' do
    #   ep = SubtitulosDownloader::Movie.new_from_file_name("Fringe.S04E07.HDTV.XviD-LOL.avi.avi")
    #   ep.show_name.should == 'Fringe'
    #   ep.season.should == 4
    #   ep.episode.should == 7
    # end

    # it 'should fetch data from TVdb' do
    #   ep = SubtitulosDownloader::Movie.new_from_file_name("Fringe.S04E07.HDTV.XviD-LOL.avi.avi", {:tvdb_api_key => 'EF41E54C744526F7'})
    #   ep.episode_name.should == 'Wallflower'
    # end

    # it 'should show the episode full name' do
    #   ep = SubtitulosDownloader::Movie.new_from_file_name("Fringe.S04E07.HDTV.XviD-LOL.avi.avi", {:tvdb_api_key => 'EF41E54C744526F7'})
    #   ep.full_name.should == 'Fringe - 4x07 - Wallflower'
    #   episode = SubtitulosDownloader::Movie.new('Raising Hope', 2, 4)
    #   episode.full_name.should == 'Raising Hope - 2x04'
    # end

    # it 'should show the subtitle given a language' do
    #   episode = SubtitulosDownloader::Movie.new('fake show', 3, 3)
    #   subtitle = SubtitulosDownloader::Subtitle.new('subs', 'es', episode)
    #   sub = episode.subtitle_language 'es'
    #   sub.should == subtitle
    #   sub.subtitles.should =='subs'

    # end

  end

  context "Paths" do
    # before(:all) do
    #   @ep = SubtitulosDownloader::Movie.new_from_file_name("Fringe.S04E07.HDTV.XviD-LOL.avi.avi", {:tvdb_api_key => 'EF41E54C744526F7'})
    # end
    # it 'should show the show path' do
    #   @ep.show_path.should == 'Fringe'
    # end

    # it 'should show the season path' do
    #   @ep.season_path.should == 'Fringe/Season 4'
    # end

    # it 'should show the episode path' do
    #   @ep.episode_path.should == 'Fringe/Season 4/Fringe - 4x07 - Wallflower'
    # end
  end

  context "Exceptions" do
  
    # it 'should raise a show not found exception' do
    #   lambda{ SubtitulosDownloader::Movie.new('fake show', 4, 5, {:tvdb_api_key => 'EF41E54C744526F7'}) }.should raise_error(SubtitulosDownloader::ShowNotFound)
    # end
  end
end
