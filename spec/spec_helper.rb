require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'subtitulos_downloader'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter  = 'documentation'
end