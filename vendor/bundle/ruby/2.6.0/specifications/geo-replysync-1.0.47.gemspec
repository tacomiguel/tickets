# -*- encoding: utf-8 -*-
# stub: geo-replysync 1.0.47 ruby lib

Gem::Specification.new do |s|
  s.name = "geo-replysync".freeze
  s.version = "1.0.47"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.geosatelital.red" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["MarkGS".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-01-25"
  s.description = "".freeze
  s.email = ["mtantalean@geosatelital.com".freeze]
  s.homepage = "".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.0.8".freeze
  s.summary = "Geo ReplySync".freeze

  s.installed_by_version = "3.0.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<aes-everywhere>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<faraday>.freeze, ["~> 0.17.1"])
    else
      s.add_dependency(%q<aes-everywhere>.freeze, [">= 0"])
      s.add_dependency(%q<faraday>.freeze, ["~> 0.17.1"])
    end
  else
    s.add_dependency(%q<aes-everywhere>.freeze, [">= 0"])
    s.add_dependency(%q<faraday>.freeze, ["~> 0.17.1"])
  end
end
