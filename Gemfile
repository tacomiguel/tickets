source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  # gem 'letter_opener'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'dotenv-rails'
gem 'mysql2', '~> 0.5.3'
gem 'devise', '~> 4.7'
gem 'pagy'
gem 'awesome_print'

gem 'jquery-ui-rails'
gem 'rails_sortable'

# gema para graficos reports
gem 'chartkick'
# gemas para reportes execl y pdf
gem 'caxlsx_rails'
gem 'prawn'
gem 'prawn-table'
# gema para UUID
gem 'uuidable'
# gema para formato email
gem "bootstrap-email", "~> 0.3.4"
# gemas sidekiq tareas en segundo plano
gem 'sidekiq'
gem 'redis-namespace'
gem 'sidekiq-cron'
# gema para llamdas http
gem 'faraday', "~> 0.17.1"
# gema para paginacion en api-rest
gem 'api-pagination'

source 'https://rubygems.geosatelital.red' do
   gem 'gnext', '1.0.18'
   gem 'geo-replysync', '1.0.47'
end
