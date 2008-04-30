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
  end
end