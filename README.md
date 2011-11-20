Subtitulos Downloader
=====================
Subtitulos Downloader is a gem to download subtitles focused in spanish language.

Description
-----------
Subtitles Downloader can use different subtitles providers to fetch the files from different webs.
It allows to download subtitles for multiple languages supported by the provider used.

It also supports TVdb to fetch the episode name and the real name for the show given a season and an episode number.

It saves the file(s) to a given path.Right now, only supported format name is:
<Show Name/Season #/Show Name - SxEE - Episode Name-Language.srt>


### Providers
The providers currently developed are:
* [subtitulos.es](http://www.subtitulos.es)


Installation
------------
To install the gem

  gem install subtitulos_downloader


Usage
-----
For using this gem all you have to do is
  
  require 'subtitulos_downloader'
  sub_downloader = SubtitulosDownloader::SubtitulosDownloader({ 
    :provider = SubtitulosDownloader::SubtitlosEs,
    :tvdb_api_key = 'XXXXXXXXXXXXX'
  })

  # Fetching spanish subtitles given a show name, season and episode
  episode = sub_downloader.fetch('Fringe', 4, 7, %w[ es ])

  # Fetching english subtitles given a file name
  episode = sub_downloader.fetch_by_file_name('Fringe.S04E07.HDTV.XviD-LOL.avi.avi', %w[ en ])

  # Fetching english and spanish subtitles given an episode object
  episode = SubtitulosDownloader::ShowEpisode.new_from_file_name('Fringe.S04E07.HDTV.XviD-LOL.avi.avi', {:tvdb_api_key = 'XXXXXXX'})
  sub_downloader.fetch_by_show_episode(episode, %w[ es en ])
        
  # To save the subtitles
  # Ex: /path_to_save/Fringe/Season 4/Fringe - 4x07 - Wallflower-English.srt
  sub_downloader.save_subs_to_path(episode, '/path_to_save')

  # Episode Object
  episode = 
  subs = episode.subtitles # Array containing all subtitles for the episode
  name = episode.full_name # Ex: Fringe - 4x07 - Wallflower
  ep_name = episode.episode_name # Ex: Wallflower
  season = episode.season # Ex: 4
  episode = episode.episode # Ex: 7
  show = episode.show_name # Ex: Fringe

  # Subtitle Object
  subtitles = episode.subtitles.first
  subtitles.language # Language of subtitles
  subtitles.subtitles # String containing the subtitles


Contact
------
Héctor Sánchez-Pajares
[hector@aerstudio.com](mailto:hector@aerstudio.com)






