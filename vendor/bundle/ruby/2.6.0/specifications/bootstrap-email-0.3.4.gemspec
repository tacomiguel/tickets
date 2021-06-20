# -*- encoding: utf-8 -*-
# stub: bootstrap-email 0.3.4 ruby lib

Gem::Specification.new do |s|
  s.name = "bootstrap-email".freeze
  s.version = "0.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Stuart Yamartino".freeze]
  s.date = "2021-01-08"
  s.email = "stu@stuyam.com".freeze
  s.homepage = "https://bootstrapemail.com".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "3.0.8".freeze
  s.summary = "Bootstrap 4 stylesheet, compiler, and inliner for responsive and consistent emails with the Bootstrap syntax you know and love.".freeze

  s.installed_by_version = "3.0.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionmailer>.freeze, [">= 3"])
      s.add_runtime_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
      s.add_runtime_dependency(%q<premailer-rails>.freeze, ["~> 1.9"])
      s.add_runtime_dependency(%q<rails>.freeze, [">= 3"])
    else
      s.add_dependency(%q<actionmailer>.freeze, [">= 3"])
      s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
      s.add_dependency(%q<premailer-rails>.freeze, ["~> 1.9"])
      s.add_dependency(%q<rails>.freeze, [">= 3"])
    end
  else
    s.add_dependency(%q<actionmailer>.freeze, [">= 3"])
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
    s.add_dependency(%q<premailer-rails>.freeze, ["~> 1.9"])
    s.add_dependency(%q<rails>.freeze, [">= 3"])
  end
end
