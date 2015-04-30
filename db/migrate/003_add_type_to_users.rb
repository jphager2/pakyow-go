class AddTypeToUsers < ActiveRecord::Migration
  add_column :users, :type, :string
end
