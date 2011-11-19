require 'spec_helper'


describe SubtitulosDownloader::ShowEpisode do

  context "Initializing" do

    it 'should create a new show episode from show name, season number and episode number' do
      episode = SubtitulosDownloader::ShowEpisode.new('Raising Hope', 2, 4)
      episode.show_name.should == 'Raising Hope' 
      episode.season.should == 2
      episode.episode.should == 4
    end

    it 'should create a new show episode from a file name' do
      ep = SubtitulosDownloader::ShowEpisode.new_from_file_name("Fringe.S04E07.HDTV.XviD-LOL.avi.avi")
      ep.show_name.should == 'Fringe'
      ep.season.should == 4
      ep.episode.should == 7
    end

    it 'should fetch data from TVdb' do
      ep = SubtitulosDownloader::ShowEpisode.new_from_file_name("Fringe.S04E07.HDTV.XviD-LOL.avi.avi", {:tvdb_api_key => 'EF41E54C744526F7'})
      ep.episode_name.should == 'Wallflower'
    end

    it 'should show the episode full name' do
      ep = SubtitulosDownloader::ShowEpisode.new_from_file_name("Fringe.S04E07.HDTV.XviD-LOL.avi.avi", {:tvdb_api_key => 'EF41E54C744526F7'})
      ep.full_name.should == 'Fringe - 4x07 - Wallflower'
      episode = SubtitulosDownloader::ShowEpisode.new('Raising Hope', 2, 4)
      episode.full_name.should == 'Raising Hope - 2x04'
    end

  end

  context "Paths" do
    before(:all) do
      @ep = SubtitulosDownloader::ShowEpisode.new_from_file_name("Fringe.S04E07.HDTV.XviD-LOL.avi.avi", {:tvdb_api_key => 'EF41E54C744526F7'})
    end
    it 'should show the show path' do
      @ep.show_path.should == 'Fringe'
    end

    it 'should show the season path' do
      @ep.season_path.should == 'Fringe/Season 4'
    end

    it 'should show the episode path' do
      @ep.episode_path.should == 'Fringe/Season 4/Fringe - 4x07 - Wallflower'
    end
    


  end


end
