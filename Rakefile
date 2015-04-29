require 'pakyow-rake'
require 'active_record'

# put your rake task here
desc 'database tasks'
namespace :db do
  desc 'Run active record migrations in db/migrate'
  task :migrate => [:'pakyow:prepare'] do
    ActiveRecord::Migrator.migrate(
      File.expand_path(File.dirname(__FILE__) + '/db/migrate'), nil
    )
  end
end

