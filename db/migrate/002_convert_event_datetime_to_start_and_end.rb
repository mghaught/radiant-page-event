class ConvertEventDatetimeToStartAndEnd < ActiveRecord::Migration
  def self.up
    add_column :pages, :event_datetime_start, :datetime
    add_column :pages, :event_datetime_end, :datetime
    Page.find(:all).each do |page|
      page.update_attributes :event_datetime_start => page.event_datetime
    end
    remove_column :pages, :event_datetime
  end

  def self.down
    add_column :pages, :event_datetime, :datetime
    Page.find(:all).each do |page|
      page.update_attributes :event_datetime => page.event_datetime_start
    end
    remove_column :pages, :event_datetime_start
    remove_column :pages, :event_datetime_end
  end
end
