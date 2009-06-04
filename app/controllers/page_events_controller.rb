class PageEventsController < ApplicationController

  def index
    
    if !params[:year].blank? and !params[:month].blank?
      @date = Time.local(params[:year], params[:month])
    else
      @date = (params[:date] || Time.now).to_time
    end
    
    @last_month = @date.last_month.to_date
    @next_month = @date.next_month.to_date
    @last_month_count = Page.event_count_by_month(@date.last_month)
    @next_month_count = Page.event_count_by_month(@date.next_month)
    
    if @last_month_count == 0
      if @last_eventful_month = Page.last_eventful_month(@date)
        @last_eventful_month_count = Page.event_count_by_month(@last_eventful_month)
      end
    end
    
    if @next_month_count == 0
      if @next_eventful_month = Page.next_eventful_month(@date)
        @next_eventful_month_count = Page.event_count_by_month(@next_eventful_month)
      end
    end
    
    # debugger
    
    @current_events = Page.events_by_month(@date)
  end
end
