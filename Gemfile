source 'https://rubygems.org'

ruby '2.1.4'
gem 'rails', '4.1.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'american_date'
gem 'active_decorator'
gem "active_model_serializers"
gem 'angularjs-rails'
gem 'aws-sdk'
gem 'bootstrap-sass'
gem 'coffee-rails', '~> 4.0.0'
gem 'chronic'
gem 'devise'
gem 'has_scope'
gem 'enumerize'
gem 'factory_girl_rails'
gem 'faker'
gem 'font-awesome-rails'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'kaminari'
gem 'money-rails' # for currency values
gem 'non-stupid-digest-assets'
gem 'numbers_and_words'
gem 'pg'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'simple_form'
gem 'slim-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'table_print' # http://tableprintgem.com/
gem 'paperclip', '~> 3.0'
gem 'paper_trail', '~> 4.0.0.beta'
gem 'validates_overlap'
gem 'versionist'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'will_paginate', '~> 3.0'
gem 'validates_timeliness'
gem "paranoia", "~> 2.0"

group :production do
  gem 'rails_12factor'

  # Heroku Webserver will use Unicorn.
  gem 'unicorn'
end

group :development do
    gem 'sprint'
    gem 'bullet'
    gem 'pry-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'quiet_assets'
  gem 'shoulda-matchers'
  gem 'letter_opener'

  # https://github.com/dejan/rails_panel
  gem 'meta_request'

  # https://github.com/charliesome/better_errors
  gem 'better_errors'
  gem 'binding_of_caller'

  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
end
