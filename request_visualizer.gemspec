# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "request_visualizer/version"

Gem::Specification.new do |s|
  s.name        = "request_visualizer"
  s.version     = RequestVisualizer::VERSION
  s.authors     = ["Jacob Burkhart"]
  s.email       = ["jacob@engineyard.com"]
  s.homepage    = ""
  s.summary     = %q{Rack middleware for visualizing HTTP/JSON requests}
  s.description = %q{Rack middleware for visualizing HTTP/JSON requests, and stuff}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'colored'
end
