source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'jquery-datatables-rails', '~> 3.4.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks', '~> 5'

# gem 'redis', '~> 3.0'
# gem 'bcrypt', '~> 3.1.7'
# gem 'capistrano-rails', group: :development

gem 'devise'
gem "paranoia", "~> 2.2"
gem 'kaminari'
gem 'simple_form'
gem 'unicode_utils'
gem "cancan"
gem 'lightbox-bootstrap-rails', '5.1.0.1'

gem "gon"
gem 'haml'
gem 'haml-rails', '~> 0.9'
gem 'ng-toaster-rails'

gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootstrap-kaminari-views'
gem 'angularjs-rails'

gem 'cocoon' # dinamyc forms
gem 'jquery-turbolinks'

gem 'sidekiq'
gem 'rails4-autocomplete'

gem 'paperclip'
gem 'htmltoword'
gem 'wicked_pdf'
gem 'mail'
gem 'wkhtmltopdf-binary'
gem 'rtf'
gem 'rollbar'

gem 'grape'
gem 'grape-swagger'
gem 'grape-swagger-rails'

# gem 'cancancan'
# https://github.com/rubysherpas/paranoia

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'

  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'mina'
  gem 'mina-sidekiq'
  gem 'rubocop', '~> 0.49.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
