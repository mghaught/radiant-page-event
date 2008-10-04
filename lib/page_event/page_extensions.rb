module PageEvent::PageExtensions
	
	def self.included(base)
    base.extend ClassMethods
  end	

  module ClassMethods
		def events_by_month(date = Time.now, status = nil)
			month_start = date.at_beginning_of_month
			condition_str = "event_datetime #{(month_start .. month_start.next_month - 1.minute).to_s(:db)}"
			condition_str << " AND status_id = #{status}"  if status
			
			Page.find(:all,:conditions => condition_str)		
		end
		
		def event_count_by_month(date = Time.now)
			month_start = date.at_beginning_of_month
			Page.count(:conditions => ["event_datetime_start >= :month_start OR event_datetime_end < :month_end",
                                {
                                  :month_start => month_start,
                                  :month_end => month_start.next_month
                                }])		
		end		
		
		def next_event
			upcoming_events(1).first
		end	
				
		def upcoming_events(limit = 3)
			Page.find(:all, 
				:conditions => ["event_datetime_start >= :event AND status_id = :status", {
					:event => Time.now.to_s(:db),
					:status => Status['published'].id
				}], 
				:order => "event_datetime_start, event_datetime_end", :limit => limit)		
		end	
  end
end
