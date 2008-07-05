class PageEventsController < ApplicationController

	def index
		@date = (params[:date] || Time.now).to_time
		
		@last_month = @date.last_month.to_date
		@next_month = @date.next_month.to_date		
		@last_month_count = Page.event_count_by_month(@date.last_month)
		@next_month_count = Page.event_count_by_month(@date.next_month)
		
		@current_events = Page.events_by_month(@date)
	end
end
