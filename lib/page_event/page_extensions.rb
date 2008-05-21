module PageEvent::PageExtensions
	
	def self.included(base)
    base.extend ClassMethods
  end	

  module ClassMethods
		def events_by_month(date = Time.now)
			month_start = date.at_beginning_of_month
			Page.find(:all,:conditions => "event_datetime #{(month_start .. month_start.next_month - 1.minute).to_s(:db)}")		
		end
		
		def event_count_by_month(date = Time.now)
			month_start = date.at_beginning_of_month
			Page.count(:conditions => "event_datetime #{(month_start .. month_start.next_month - 1.minute).to_s(:db)}")		
		end		
		
		def next_event
			upcoming_events(1).first
		end	
				
		def upcoming_events(limit = 3)
			Page.find(:all, 
				:conditions => ["event_datetime >= :event AND status_id = :status", {
					:event => Time.now.to_s(:db),
					:status => Status['published'].id
				}], 
				:order => "event_datetime", :limit => limit)		
		end	
  end
end