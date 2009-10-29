class ConvertEventDatetimeToStartAndEnd < ActiveRecord::Migration
  def self.up
    rename_column :pages, :event_datetime, :event_datetime_start 
    add_column :pages, :event_datetime_end, :datetime
  end

  def self.down
    remove_column :pages, :event_datetime_end
    rename_column :pages, :event_datetime_start, :event_datetime
  end
end
