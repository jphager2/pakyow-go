require 'bundler/setup'

require 'pakyow'
require 'active_record'
require 'ruby-go'

Pakyow::App.define do
  configure :global do
    # put global config here and they'll be available across environments
    app.name = 'Pakyow'
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
  end
end
