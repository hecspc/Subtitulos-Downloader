require 'spec_helper'


describe SubtitulosDownloader::Subtitle do

  context "Initializing" do
    before(:all) do
      @ep = SubtitulosDownloader::ShowEpisode.new_from_file_name("Fringe.S04E07.HDTV.XviD-LOL.avi.avi", {:tvdb_api_key => 'EF41E54C744526F7'})
    end

    it 'should initialize' do
      sub = SubtitulosDownloader::Subtitle.new('subs', 'en', @ep)
      sub.subtitles.should == 'subs'
      sub.language.should == 'en'
      sub.show_episode.should == @ep
      @ep.subtitles.count.should == 1
      @ep.subtitles.first.should == sub
    end

    it 'should show the path to save' do
      sub = SubtitulosDownloader::Subtitle.new('subs', 'en', @ep)
      sub.save_path.should == 'Fringe/Season 4/Fringe - 4x07 - Wallflower-English.srt'
      sub = SubtitulosDownloader::Subtitle.new('subs', 'es', @ep)
      sub.save_path.should == 'Fringe/Season 4/Fringe - 4x07 - Wallflower-Spanish.srt'
      sub = SubtitulosDownloader::Subtitle.new('subs', 'ca', @ep)
      sub.save_path.should == 'Fringe/Season 4/Fringe - 4x07 - Wallflower-ca.srt'
    end

  end

end