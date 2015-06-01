source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'

# DB
gem 'pg'
gem 'yaml_db', github: 'mauriciopasquier/yaml_db', branch: 'order-join-tables'
gem 'json'

# Estamos varados acá hasta que se arregle el tema con gcc 4.9
gem 'libv8', '3.16.14.3'

# Assets
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'turbolinks'
gem 'therubyracer'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'handlebars_assets'
gem 'bootstrap-sass-rails'
gem 'awesome_nested_fields'
gem 'bootstrap-datepicker-rails'
gem 'rails4-autocomplete'
gem 'font-awesome-sass', '~> 4.3.0'

# Usuarios
gem 'devise'

# Idiomas
gem 'rails-i18n'
gem 'devise-i18n'

# Development
gem 'pry-rails'
gem 'hirb'

# con 5.6 se rompe el parallel executor y no tengo tiempo de debuguearlo
gem 'minitest', '5.5.1'
gem 'minitest-rails'
gem 'dotenv-rails'

group :development do
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'capistrano3-delayed-job'
end

group :test do
  gem 'selenium-webdriver'
  gem 'minitest-rails-capybara'
  gem 'database_cleaner'
  gem 'minitap'
  gem 'capybara-screenshot'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'spring'
end
