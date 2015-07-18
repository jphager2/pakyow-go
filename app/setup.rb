require 'bundler/setup'

require 'pakyow'
require 'active_record'
require 'ruby-go'
require 'letter_opener'

Pakyow::App.define do
  configure :global do
    # put global config here and they'll be available across environments
    app.name = 'Pakyow-Go'
    mailer.default_sender = app.name
    mailer.delivery_method = LetterOpener::DeliveryMethod
    mailer.delivery_options[:location] = File
      .expand_path('../tmp/letter_opener', __FILE__)
  end

  configure :development do
    # put development config here

    require 'dotenv'
    Dotenv.load

    $db = ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3', database: ENV["DATABASE_PATH"]
    )
  end

  configure :prototype do
    # an environment for running the front-end prototype with no backend
    app.ignore_routes = true
  end

  configure :staging do
    # put your staging config here
  end

  configure :production do
    # put your production config here
    # heroku fixes
    app.log_output = true 
    app.static = true

    $db = ActiveRecord::Base.establish_connection
  end

  middleware do |builder|
    builder.use Rack::Session::Cookie, key: "pakyowgo.session", secret: ENV["APP_SECRET"]
  end
end
