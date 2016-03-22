# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "att_speech"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Goecke, Peter Wilson"]
  s.date = "2013-05-09"
  s.description = "A Ruby library for consuming v3 of the AT&T Speech API for speech->text, and text->speech. Takes in either .wav or specific other audio files, and returns a text string of the spoken words. Can also take in either a text string or .txt file and returns a string of bytes from which a .wav file can be created of the spoken text."
  s.email = "jason@goecke.net"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "att_speech.gemspec",
    "examples/bostonSeltics.wav",
    "examples/example.rb",
    "examples/helloWorld.txt",
    "lib/att_speech.rb",
    "lib/att_speech/att_speech.rb",
    "lib/att_speech/version.rb",
    "spec/att_speech_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/jsgoecke/att_speech"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A Ruby library for consuming the AT&T Speech API https://developer.att.com/developer/forward.jsp?passedItemId=12500023 for speech->text, and text->speech."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>, [">= 0.8.1"])
      s.add_runtime_dependency(%q<hashie>, [">= 1.2.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_development_dependency(%q<yard>, [">= 0.7"])
      s.add_development_dependency(%q<rdoc>, [">= 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 1.8.4"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
    else
      s.add_dependency(%q<faraday>, [">= 0.8.1"])
      s.add_dependency(%q<hashie>, [">= 1.2.0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_dependency(%q<yard>, [">= 0.7"])
      s.add_dependency(%q<rdoc>, [">= 3.12"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>, [">= 1.8.4"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
    end
  else
    s.add_dependency(%q<faraday>, [">= 0.8.1"])
    s.add_dependency(%q<hashie>, [">= 1.2.0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.8.0"])
    s.add_dependency(%q<yard>, [">= 0.7"])
    s.add_dependency(%q<rdoc>, [">= 3.12"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, [">= 1.8.4"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
  end
end

