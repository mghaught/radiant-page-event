class AddAllDayEvents < ActiveRecord::Migration
  def self.up
    add_column :pages, :event_all_day, :boolean
  end

  def self.down
    remove_column :pages, :event_all_day
  end
end
