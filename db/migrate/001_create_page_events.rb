class CreatePageEvents < ActiveRecord::Migration
  def self.up
    add_column :pages, :event_datetime_start, :datetime
    add_column :pages, :event_datetime_end, :datetime
  end

  def self.down
    remove_column :pages, :event_datetime_start
    remove_column :pages, :event_datetime_end
  end
end
