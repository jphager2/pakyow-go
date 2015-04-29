require 'pakyow-rake'
require 'active_record'

# put your rake task here
desc 'database tasks'
namespace :db do
  desc 'Run active record migrations in db/migrate'
  task :migrate do
    ActiveRecord::Base.establish_connection(
      adapter:  "sqlite3",
      database: "/home/john/projects/pakyow/pakyow-go/db/development.sqlite3"
    )
    ActiveRecord::Migrator.migrate(
      File.expand_path(File.dirname(__FILE__) + '/db/migrate'), nil
    )
  end
end

