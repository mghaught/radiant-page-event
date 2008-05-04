module PageEventTags
  include Radiant::Taggable
  include PageEvent::CalendarSupport

	tag "event" do |tag|
		tag.expand if tag.locals.page.event_datetime
	end

	tag "event:date" do |tag|
		tag.locals.page.event_datetime.strftime("%m/%d/%Y") if tag.locals.page.event_datetime
	end
  
	tag "event:time" do |tag|
		tag.locals.page.event_datetime.strftime("%I:%M %p") if tag.locals.page.event_datetime
	end

	tag	"calendar" do |tag|
		params = tag.locals.page.request.parameters

		begin
			selected_date = params["date"].to_time if params["date"]
		rescue
			logger.error "Date param, #{params["date"]}, did not parse correctly" 
		end
		
		selected_date ||= Time.now
		
		prev_month = selected_date - 1.month
		next_month = selected_date + 1.month		
		events_by_date = events_for(selected_date) # TODO - needs to limit events to the published status
		
		Date::MONTHNAMES[selected_date.mon]

    html = Builder::XmlMarkup.new
    table = html.table(:class => "calendar", :border => 0, :cellspacing => 0, :cellpadding => 0) do
      html.thead do
      	html.tr(:class => "monthHeader") do
      		html.th(:class => "monthLink") do
      			html.a(:href => "", :title => Date::MONTHNAMES[prev_month.mon], :onclick => date_onclick(prev_month.to_s(:db))) { |x| x << "&#171;"}
      		end
					html.th("#{Date::MONTHNAMES[selected_date.mon]} #{selected_date.year}", :class => "monthName", :colspan => 5) 
	      		html.th(:class => "monthLink") do
	      			html.a(:href => "", :title => Date::MONTHNAMES[next_month.mon], :onclick => date_onclick(next_month.to_s(:db))) { |x| x << "&#187;" }
	      		end
	      	end
				html.tr(:class => "dayName") do
					# This calendar currently only supports starting on Sunday and ending on Saturday
					Date::DAYNAMES.each do |day|
						html.th(:scope => "col") do
							html.abbr(day[0..1], :title => day) 
						end						
					end
				end
			end

			html.tbody do
				calendar_weeks(selected_date).each do |week|
					html.tr do
						week.each do |day|
							html_classes = ""
							add_html_class(html_classes,"otherMonth") unless day.month == selected_date.month
							add_html_class(html_classes,"weekend") if weekend?(day) 
							add_html_class(html_classes,"today") if today?(day)

							html.td(:class => html_classes) do
								html.div(:class => "day") do
									html.div(day.mday, :class => "date")
									
									if events_by_date.has_key?(day)
										html.div(:class => "eventContainer") do
											events_by_date[day].each do |event|
												html.p(:class => "event") do
													html.span(event.event_datetime.strftime("%I:%M %p"), :class => "time") 
													html.a(event.title, :href => event.url) 	
												end
											end
										end						
									end			 
								end
							end	
						end						
					end
				end
			end
    end		
	end
end