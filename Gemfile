source 'https://rubygems.org'

gem 'rails', '3.2.8'

gem 'pg'
gem 'bootstrap-sass', '~> 2.0.4.0' #Added first edit  
gem 'thin'   #Added first edit  

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'execjs'   #Added first edit in group :asset  
  gem 'therubyracer', :platforms => :ruby  #Uncomment first edit  in group :asset 

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# group :development do #Added first edit  
  gem 'haml-rails'  
  gem 'hpricot'  
  gem 'ruby_parser'  
#end

group :development, :test do #Added first edit  
  gem "rspec-rails", '~> 2.6'  
  gem 'capybara'    
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i  
  gem "foreman", "~> 0.51.0"  
end  
