require 'bundler/setup'

require 'pakyow'
require 'active_record'
require 'ruby-go'
require 'letter_opener'

module JohnsHelper
  def self.print_config(config, logger, indent = 0)
    Array(config).each do |name, value|
      if inner_config = value.instance_variable_get(:@envs)
        logger.info name.to_s
        inner_config = inner_config[:production].instance_variable_get(:@opts)
        defaults = value.defaults.instance_variable_get(:@opts)
        if inner_config
          opts = defaults.merge inner_config
        else
          opts = defaults
        end
        print_config(opts, logger, indent)
      else
        logger.info "#{" " * indent}#{name}: #{value}"
      end
    end
    puts
  end
end

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
    app.static = true
    logger.stdout = true
    #realtime.registry = Pakyow::Realtime::SimpleRegistry
    realtime.redis = { url: "redis://h:p7vo203cje5f5o48slhgm2ds1ko@ec2-54-235-76-229.compute-1.amazonaws.com:6909" }

    $db = ActiveRecord::Base.establish_connection
  end

  Pakyow::App.after(:configure) do
    config = Pakyow::App.config.instance_variable_get(:@config)
    JohnsHelper.print_config(config, Pakyow.logger)
  end
end


