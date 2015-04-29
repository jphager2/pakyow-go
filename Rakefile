require 'pakyow-rake'
require 'active_record'
require 'dotenv'

# put your rake task here
desc 'database tasks'
namespace :db do
  desc 'Run active record migrations in db/migrate'
  task :migrate do
    Dotenv.load
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3', database: ENV["DATABASE_PATH"]
    )
    ActiveRecord::Migrator.migrate(
      File.expand_path(File.dirname(__FILE__) + '/db/migrate'), nil
    )
  end
end

