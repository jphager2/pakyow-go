require 'pakyow-rake'
require 'active_record'

# put your rake task here
desc 'database tasks'
namespace :db do
=begin
  desc 'Drop the database (only in production)'
  task :drop => [:'pakyow:prepare'] do
    ActiveRecord::Base.connection.drop_database($db.spec.config[:database])
  end

  desc 'Create the database (only in production)'
  task :create => [:'pakyow:prepare'] do
    ActiveRecord::Base.connection.create_database(ENV["DATABASE_NAME"])
  end
=end
  desc 'Run active record migrations in db/migrate'
  task :migrate => [:'pakyow:prepare'] do
    ActiveRecord::Migrator.migrate(
      File.expand_path(File.dirname(__FILE__) + '/db/migrate'), nil
    )
  end
end

