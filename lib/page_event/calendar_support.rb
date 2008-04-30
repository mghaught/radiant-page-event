module PageEvent::CalendarSupport

	def events_for(selected_date)
		events = Page.events_by_month(selected_date)
		events_by_date = {}
		events.map do |e|
			event_date = e.event_datetime.to_date
			events_by_date[event_date] ||= []
			events_by_date[event_date] << e
		end		
		events_by_date
	end
	
	def date_onclick(date_str) 
		"var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href; var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', 'date'); m.setAttribute('value', '#{date_str}'); f.appendChild(m); f.submit(); return false;"
	end
		
	def add_html_class(html_classes, new_class)
		html_classes << " " if html_classes.size > 0
		html_classes << new_class
	end
	
	def first_sunday(date)
		first_day_of_month = date.beginning_of_month					
		first_sunday = first_day_of_month.wday == 0 ? first_day_of_month : first_day_of_month - (first_day_of_month.wday).days
		logger.debug "First sunday of the month is #{first_sunday}, wday is #{first_sunday.wday}, month is #{first_sunday.month}"		
		first_sunday.to_date
	end

	def last_saturday(date)
		last_day_of_month = date.end_of_month
		last_saturday = last_day_of_month.wday == 6 ? last_day_of_month : last_day_of_month + (6 - last_day_of_month.wday).days
		logger.debug "Last saturday of the month is #{last_saturday}, wday is #{last_saturday.wday}, month is #{last_saturday.month}"	
		last_saturday.to_date	
	end
	
	def calendar_weeks(date)
		calendar_weeks = []
		current_week = []
		first_sunday(date).upto(last_saturday(date)) do |day|
			current_week << day
			
			if day.wday == 6
				calendar_weeks << current_week.dup
				current_week = []
			end
		end
		calendar_weeks		
	end

	def weekend?(day)
		[0,6].include?(day.wday)
	end
	
	def today?(day)
		day == Time.now.to_date
	end
end