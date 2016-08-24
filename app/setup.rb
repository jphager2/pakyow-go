require 'bundler/setup'

require 'pakyow'
require 'active_record'
require 'ruby-go'
require 'letter_opener'

include RubyGo

Pakyow::App.define do
  configure :global do
    # put global config here and they'll be available across environments
    app.name = 'Pakyow-Go'
    mailer.default_sender = app.name
    mailer.delivery_method = LetterOpener::DeliveryMethod
    mailer.delivery_options[:location] = File.expand_path(
      '../tmp/letter_opener', __FILE__
    )

    config_file = File.expand_path('../config/database.yml', __dir__)
    ActiveRecord::Base.configurations = YAML.load_file(config_file)
  end

  configure :development do
    require 'dotenv'
    Dotenv.load

    $db = ActiveRecord::Base.establish_connection(:development)
  end

  configure :test do
    require 'dotenv'
    Dotenv.load

    $db = ActiveRecord::Base.establish_connection(:test)
  end

  configure :prototype do
    # an environment for running the front-end prototype with no backend
    app.ignore_routes = true
  end

  configure :staging do
  end

  configure :production do
    app.static = true
    logger.stdout = true
    realtime.redis = { url: "redis://h:p7vo203cje5f5o48slhgm2ds1ko@ec2-54-235-76-229.compute-1.amazonaws.com:6909" }

    $db = ActiveRecord::Base.establish_connection(:production)
  end
end
