class PageEvent < ActiveRecord::Base
	
	belongs_to :page
	
	before_save :validate_datetimes
	def validate_datetimes
	  # set end time to start time if start time exists and end time is not defined
	  self.event_datetime_end ||= self.event_datetime_start unless self.event_datetime_start.nil?

	  # set end time to nil if no start time is defined
	  self.event_datetime_end = nil if self.event_datetime_start.nil?
	  
	  # if the event has a negative duration, flip the start and end times
	  if self.event_datetime_start && self.event_datetime_start && self.event_datetime_start > self.self.event_datetime_end
	    orig_start = self.event_datetime_start
	    self.event_datetime_start = self.event_datetime_end
	    self.event_datetime_end = self.event_datetime_start
	  end
	end
end
