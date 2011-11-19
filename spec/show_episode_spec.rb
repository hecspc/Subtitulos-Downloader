require 'spec_helper'

describe SubtitulosDownloader::ShowEpisode do

  it 'should create a new show episode from show name, season number and episode number' do
    episode = SubtitulosDownloader::ShowEpisode.new('Raising Hope', 2, 4)
  end

end