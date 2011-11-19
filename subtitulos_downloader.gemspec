# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "subtitulos_downloader/version"

Gem::Specification.new do |s|
  s.name        = "subtitulos_downloader"
  s.version     = SubtitulosDownloader::VERSION
  s.authors     = ["hector spc"]
  s.email       = ["hector@aerstudio.com"]
  s.homepage    = "https://github.com/hecspc/Subtitulos-Downloader"
  s.summary     = "Fetch subtitles focused on spanish language"
  s.description = "Fetch subtitles from different providers and save them to a given path"

  s.rubyforge_project = "subtitulos_downloader"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~>2.0"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency("tvdb", ">= 0.1.0")
  s.add_dependency("hpricot", ">= 0.8.4")
  s.add_dependency("httparty", ">= 0.8.1")
  s.add_dependency("prowler", ">= 1.3.1")
end
