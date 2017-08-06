source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails'
gem 'rails'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-datatables-rails', '~> 3.4.0'

gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# gem 'redis', '~> 3.0'
# gem 'bcrypt', '~> 3.1.7'
# gem 'capistrano-rails', group: :development
gem 'listen'
gem 'pg'
gem "paranoia", "~> 2.2"
gem 'devise'
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

gem "cocoon" # dinamyc forms
gem 'jquery-turbolinks'

gem 'sidekiq'
gem 'rails4-autocomplete'

gem 'paperclip'
gem 'htmltoword'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'rtf'
gem 'mail'

# gem 'cancancan'
# https://github.com/rubysherpas/paranoia

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'mina'
  gem 'mina-sidekiq'
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
