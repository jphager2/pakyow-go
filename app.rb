require 'bundler/setup'

require 'pakyow'
require 'ruby-go'

Pakyow::App.define do
  configure :global do
    # put global config here and they'll be available across environments
    app.name = 'Pakyow'
  end

  configure :development do
    # put development config here
    app.database_url = "/home/john/projects/pakyow/pakyow-go/db/development.sqlite3"
    app.adapter = "sqlite3"
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
