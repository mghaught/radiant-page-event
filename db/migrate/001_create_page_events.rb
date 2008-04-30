class CreatePageEvents < ActiveRecord::Migration
  def self.up
    add_column :pages, :event_datetime, :datetime
  end

  def self.down
    remove_column :pages, :event_datetime
  end
end
