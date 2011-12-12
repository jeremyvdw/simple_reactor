# A sample Gemfile
source :gemcutter

group :development, :test do
  gem 'bundler', ">= 1.1.rc"
  gem 'ruby-debug19'
  gem 'guard', :git => 'git://github.com/guard/guard.git'
  gem 'guard-rspec'
  
  if RUBY_PLATFORM =~ /darwin/i
    gem 'growl' 
    gem 'rb-fsevent', :require => false
  end
end

group :development do
  gem "pry"
  gem "pry-doc"
end

group :test do
  gem 'rspec'
  gem 'fabrication'
end