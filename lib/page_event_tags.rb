module PageEventTags
  include Radiant::Taggable
  include PageEvent::CalendarSupport

	tag "event" do |tag|
		tag.expand if tag.locals.page.event_datetime_start
	end
	
  desc %{
	  Renders the start date of the page event.
	  
	  *Usage*:
	  
	  <pre><code><r:event:date [format="%B %e, %Y"] /></pre></code>
	}
	tag "event:date" do |tag|
	  format = tag.attr['format'] || "%m/%d/%Y"
		tag.locals.page.event_datetime_start.strftime(format) if tag.locals.page.event_datetime_start
	end
  
  desc %{
	  Renders the start time of the page event.
	  
	  *Usage*:
	  
	  <pre><code><r:event:date [format="%I:%M %p"] /></pre></code>
	}
	tag "event:time" do |tag|
	  format = tag.attr['format'] || "%I:%M %p"
		tag.locals.page.event_datetime_start.strftime(format) if tag.locals.page.event_datetime_start
	end
	
	desc %{
	  Renders the start and end datetimes of the page event. If the event starts and ends on the same day the end date is not displayed.
	  If the event starts and ends at the same time, only the start date is rendered.
	  
	  *Usage*:
	  
	  <pre><code><r:event:duration [date_format="%B %e, %Y"] [time_format="%I:%M %p"] /></pre></code>
	}
	tag "event:duration" do |tag|
	  if tag.locals.page.event_datetime_start
  	  date_format = tag.attr['date_format'] || "%m/%d/%Y"
  	  time_format = tag.attr['time_format'] || "%I:%M %p"
	    result = tag.locals.page.event_datetime_start.strftime(date_format)
	    result << ' '
		  result << tag.locals.page.event_datetime_start.strftime(time_format)
		  if tag.locals.page.event_datetime_start < tag.locals.page.event_datetime_end
		    result << '&ndash;'
		    if tag.locals.page.event_datetime_start.to_date < tag.locals.page.event_datetime_end.to_date
		      result << tag.locals.page.event_datetime_end.strftime(date_format)
		      result << ' '
	      end
	      result << tag.locals.page.event_datetime_end.strftime(time_format)
      end
	  end
	end
	
	tag "events:next" do |tag|
		if next_event = Page.next_event
      tag.locals.page = next_event
      tag.expand
    end
	end	
	
	tag "events:upcoming" do |tag|
    tag.locals.events = Page.upcoming_events
    tag.expand
	end	
	
	tag "events:upcoming:each" do |tag|
    tag.locals.events.each do |event|
      tag.locals.event = event
      tag.locals.page = event
      result << tag.expand
    end 
    result
	end
	
  tag 'events:upcoming:each:event' do |tag|
    tag.locals.page = tag.locals.event
    tag.expand
  end	
	

	tag	"events:calendar" do |tag|
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
													html.span(event.event_datetime_start.strftime("%I:%M %p"), :class => "time") 
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
	
	private
	
		def event_find_options(tag)
	    attr = tag.attr.symbolize_keys
    
	    options = {}
    
	    [:limit, :offset].each do |symbol|
	      if number = attr[symbol]
	        if number =~ /^\d{1,4}$/
	          options[symbol] = number.to_i
	        else
	          raise TagError.new("`#{symbol}' attribute of `each' tag must be a positive number between 1 and 4 digits")
	        end
	      end
	    end
    
	    by = (attr[:by] || 'published_at').strip
	    order = (attr[:order] || 'asc').strip
	    order_string = ''
	    if self.attributes.keys.include?(by)
	      order_string << by
	    else
	      raise TagError.new("`by' attribute of `each' tag must be set to a valid field name")
	    end
	    if order =~ /^(asc|desc)$/i
	      order_string << " #{$1.upcase}"
	    else
	      raise TagError.new(%{`order' attribute of `each' tag must be set to either "asc" or "desc"})
	    end
	    options[:order] = order_string
    
	    status = (attr[:status] || 'published').downcase
	    unless status == 'all'
	      stat = Status[status]
	      unless stat.nil?
	        options[:conditions] = ["(virtual = ?) and (status_id = ?)", false, stat.id]
	      else
	        raise TagError.new(%{`status' attribute of `each' tag must be set to a valid status})
	      end
	    else
	      options[:conditions] = ["virtual = ?", false]
	    end
	    options
	  end
end