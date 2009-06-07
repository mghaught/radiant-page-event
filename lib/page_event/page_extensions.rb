module PageEvent::PageExtensions
	
	def self.included(base)
    base.extend ClassMethods
  end
  
  def is_event?
    parent && 
    parent.class_name == "EventArchivePage" && 
    class_name != "EventDayIndexPage" &&
    class_name != "EventMonthIndexPage" &&
    class_name != "EventYearIndexPage" &&
    class_name != "EventSeasonIndexPage"
  end

  module ClassMethods
		def events_by_month(date = Time.now, status = nil)
			month_start = date.at_beginning_of_month
			condition_str = "(event_datetime_start >= :month_start AND event_datetime_start < :month_end)"
			condition_str << " OR (event_datetime_end >= :month_start AND event_datetime_end < :month_end)"
			condition_str << " AND status_id = #{status}"  if status
			
			Page.find(:all,:conditions => [condition_str,
                                {
                                  :month_start => month_start,
                                  :month_end => month_start.next_month
                                }])			
		end
		
		def event_count_by_month(date = Time.now)
			month_start = date.at_beginning_of_month
			condition_str = "(event_datetime_start >= :month_start AND event_datetime_start < :month_end)"
			condition_str << " OR (event_datetime_end >= :month_start AND event_datetime_end < :month_end)"
			Page.count(:conditions => [condition_str,
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
    
    
    
    def events_in_range(start=nil, finish=nil)
      begin
        if start and finish
          start_date = Time.local(*parse_date_string(start))
          end_date   = Time.local(*parse_date_string(finish))
          if end_date < start_date
            start_date, end_date = end_date, start_date
          end
          end_date = end_date.tomorrow
        elsif start
          year, month, day = parse_date_string(start)
          start_date = Time.local(year, month, day)
          end_date = case 
            when (!year.nil? and !month.nil? and !day.nil?) then start_date.tomorrow
            when (!year.nil? and !month.nil?)               then start_date.next_month
            when (!year.nil?)                               then start_date.next_year
          end
        else
          raise ArgumentError, "You must provide at least one date, in 'yyyy(/mm(/dd))' format"
        end
      rescue
        raise ArgumentError, "Dates should be provided in 'yyyy(/mm(/dd))' format."
      end
      condition_str = "(event_datetime_start >= :start_date AND event_datetime_start < :end_date)"
      condition_str << " OR (event_datetime_end >= :start_date AND event_datetime_end < :end_date)"	
      conditions = [condition_str, {:start_date => start_date, :end_date => end_date}]
      Page.find(:all, :conditions => conditions)
    end
    
    
    
    def next_eventful_month(date=Time.now)
      last_day_of_month = Date.new(date.year, date.month, -1)

      if event = Page.find(:first, 
            :conditions => ["event_datetime_start > ? AND status_id = ?", last_day_of_month, Status['published'].id], 
            :order => "event_datetime_start ASC")

        if next_event = event.event_datetime_start
          Date.new(next_event.year, next_event.month)
        end
      end
    end
    
    def last_eventful_month(date=Time.now)
      first_day_of_month = Date.new(date.year, date.month)

      if event = Page.find(:first, 
            :conditions => ["event_datetime_start < ? AND status_id = ?", first_day_of_month, Status['published'].id], 
            :order => "event_datetime_start DESC")

        if prev_event = event.event_datetime_start
          Date.new(prev_event.year, prev_event.month)
        end
      end
    end
    
    private

    def parse_date_string(input)
      input.split(/\/|-/).map{|n| n.to_i}
    end
    
  end
end
