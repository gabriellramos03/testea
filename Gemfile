source "https://rubygems.org"

# Specify Ruby version for consistency
ruby "3.2.0"  # Correspondente à versão do Ruby no Dockerfile

gem "rails", "~> 8.0.0"
gem "sprockets-rails"
gem "sqlite3", ">= 1.4", "< 2.0"  # Se estiver utilizando SQLite; remova ou substitua por outra gem de banco se necessário
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "httparty"

# If you need Redis, uncomment the lines below
# gem "redis", ">= 4.0.1"
# gem "kredis"
