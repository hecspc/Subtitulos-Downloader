# encoding: utf-8
require 'spec_helper'


describe SubtitulosDownloader::SubtitulosDownloader do

  context "Fetching" do
    before(:all) do
      @sub_downloader = SubtitulosDownloader::SubtitulosDownloader.new
    end

    it 'should fetch subtitles given name, season and episode' do
      episode = @sub_downloader.fetch('Fringe', 4, 7, %w[ es ])
      episode.subtitles.count.should == 1
      subs = (episode.subtitles.first.subtitles =~ /Ahora solo tengo que averiguar/) > 1
      subs.should == true
    end

    it 'should fetch subtitles in english and spanish by default' do
      episode = @sub_downloader.fetch('Fringe', 4, 7)
      episode.subtitles.count.should == 2
      subtitle = episode.subtitle_language 'es'
      subs = (subtitle.subtitles =~ /Ahora solo tengo que averiguar/) > 1
      subs.should == true
      subtitle = episode.subtitle_language 'en'
      subs = (subtitle.subtitles =~ /10-4. Copy location./) > 1
      subs.should == true
    end

    it 'should fetch subtitles given a file name' do
      episode = @sub_downloader.fetch_by_file_name('Fringe.S04E07.HDTV.XviD-LOL.avi.avi', %w[ es ])
      episode.subtitles.count.should == 1
      subs = (episode.subtitles.first.subtitles =~ /Ahora solo tengo que averiguar/) > 1
      subs.should == true
    end

    it 'should fetch subtitles given a show episode' do
      episode = SubtitulosDownloader::ShowEpisode.new_from_file_name('Fringe.S04E07.HDTV.XviD-LOL.avi.avi')
      @sub_downloader.fetch_by_show_episode(episode, %w[ es ])
      episode.subtitles.count.should == 1
      subs = (episode.subtitles.first.subtitles =~ /Ahora solo tengo que averiguar/) > 1
      subs.should == true
    end

  end

  context "Saving" do
    it 'should save the subtitles to disk' do
      sub_downloader = SubtitulosDownloader::SubtitulosDownloader.new
      episode = sub_downloader.fetch('Fringe', 4, 7)
      sub_downloader.save_subs_to_path(episode, '/tmp')
      episode.subtitles.each do |sub|
        exists = File.exists?('/tmp/' + sub.save_path)
        exists.should == true
      end
    end
  end
end