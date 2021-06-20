# -*- encoding: utf-8 -*-
# stub: uuidable 0.2.5 ruby lib

Gem::Specification.new do |s|
  s.name = "uuidable".freeze
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sergey Gnuskov".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-02-18"
  s.description = "".freeze
  s.email = ["sergey.gnuskov@flant.com".freeze]
  s.homepage = "https://github.com/flant/uuidable".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.8".freeze
  s.summary = "Helps using uuid everywhere in routes instead of id for ActiveRecord models.".freeze

  s.installed_by_version = "3.0.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.11"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<travis>.freeze, ["~> 1.8", ">= 1.8.2"])
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 4.2", "< 6.1"])
      s.add_runtime_dependency(%q<uuidtools>.freeze, [">= 2.1", "< 3"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.11"])
      s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<travis>.freeze, ["~> 1.8", ">= 1.8.2"])
      s.add_dependency(%q<activerecord>.freeze, [">= 4.2", "< 6.1"])
      s.add_dependency(%q<uuidtools>.freeze, [">= 2.1", "< 3"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.11"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<travis>.freeze, ["~> 1.8", ">= 1.8.2"])
    s.add_dependency(%q<activerecord>.freeze, [">= 4.2", "< 6.1"])
    s.add_dependency(%q<uuidtools>.freeze, [">= 2.1", "< 3"])
  end
end
