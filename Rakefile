require 'rake'
require 'pakyow-rake'
require 'active_record'

include ActiveRecord::Tasks

task environment: [:'pakyow:prepare'] do
  DatabaseTasks.env = ENV["RAILS_ENV"] || 'development'
  DatabaseTasks.database_configuration = YAML.load_file(
    File.expand_path('config/database.yml', __dir__)
  )
  DatabaseTasks.db_dir = 'db'
  DatabaseTasks.migrations_paths = [
    File.expand_path('db/migrate', __dir__)
  ]
  DatabaseTasks.root = File.expand_path(__dir__)
end

namespace :db do
  task drop: :environment do
    DatabaseTasks.drop_current
  end

  task create: :environment do
    DatabaseTasks.create_current
  end

  task migrate: :environment do
    DatabaseTasks.migrate
  end
end
