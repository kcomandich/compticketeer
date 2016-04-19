source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.1.15'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'puma'

gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'rspec-rails',  '~> 3.0', :require => false
  gem 'factory_girl_rails', '~> 4.0', :require => false
  gem 'database_cleaner', '~> 1.4.0', :require => false
  gem 'capybara', '~> 2.4.0', :require => false
# gem 'debugger'
end

gem 'authlogic', '~> 3.0'
gem 'aasm', '~> 4.1.0'
gem 'rest-client', '~> 1.8.0'

group :production do
  gem 'exception_notification'
  gem 'rails_12factor'
end
