# -*- encoding: utf-8 -*-
# stub: rails_sortable 1.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rails_sortable".freeze
  s.version = "1.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["itmammoth".freeze]
  s.date = "2020-08-01"
  s.description = "rails_sortable provides easy drag & drop sorting for rails 4 and 5.".freeze
  s.email = ["itmammoth@gmail.com".freeze]
  s.homepage = "https://github.com/itmammoth/rails_sortable".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.8".freeze
  s.summary = "Easy drag & drop sorting for rails.".freeze

  s.installed_by_version = "3.0.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rails>.freeze, ["~> 6.0.0"])
      s.add_development_dependency(%q<jquery-rails>.freeze, ["~> 4.3.0"])
      s.add_development_dependency(%q<jquery-ui-rails>.freeze, ["~> 6.0.0"])
      s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.4.0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 3.9.0"])
      s.add_development_dependency(%q<pry-rails>.freeze, ["~> 0.3.0"])
    else
      s.add_dependency(%q<rails>.freeze, ["~> 6.0.0"])
      s.add_dependency(%q<jquery-rails>.freeze, ["~> 4.3.0"])
      s.add_dependency(%q<jquery-ui-rails>.freeze, ["~> 6.0.0"])
      s.add_dependency(%q<sqlite3>.freeze, ["~> 1.4.0"])
      s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.9.0"])
      s.add_dependency(%q<pry-rails>.freeze, ["~> 0.3.0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, ["~> 6.0.0"])
    s.add_dependency(%q<jquery-rails>.freeze, ["~> 4.3.0"])
    s.add_dependency(%q<jquery-ui-rails>.freeze, ["~> 6.0.0"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.4.0"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.9.0"])
    s.add_dependency(%q<pry-rails>.freeze, ["~> 0.3.0"])
  end
end
