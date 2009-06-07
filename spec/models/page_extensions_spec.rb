require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
	dataset :event_pages
	
	describe "#events_by_month" do
	  it "should return a list of pages with events in the current month" do
	    Page.events_by_month.should have(3).items
	  end
	
		it "should accept a date to change the month to search within" do
		  Page.events_by_month(1.month.ago).should have(1).items
		end
	end
	
	describe "#event_count_by_month" do
	  it "should return the number of pages with events in the current month" do
	    Page.event_count_by_month.should == 3
	  end

		it "should accept a date to change the month to search within" do
		  Page.event_count_by_month(1.month.ago).should == 1
		end
	end

	describe "#upcoming_events" do
		
		before(:all) do
		  create_page "Another event", :event_datetime_start => (Time.now.at_beginning_of_month.next_month - 4.minutes).to_s(:db)
		end
		
	  it "should return the pages for the next 3 upcoming events" do
			Page.upcoming_events.should have(3).items
	  end
	
		it "should return the home page, the next event, as the first page" do
		  Page.upcoming_events.first.should == pages(:home)
		end
		
	end

	describe "#upcoming_events with more upcoming events" do
		
		before(:all) do
		  create_page "Yet another event", :event_datetime_start => (Time.now.at_beginning_of_month.next_month - 3.minutes).to_s(:db)
			create_page "Final event", :event_datetime_start => (Time.now.at_beginning_of_month.next_month - 1.minutes).to_s(:db)
		end
		
	  it "should return only return 3 events, even if there are more" do
			Page.upcoming_events.should have(3).items
	  end
	
		it "should allow more than 3 events with a different argument value" do
		  Page.upcoming_events(5).should have(5).items
		end
	end

	describe "#next_event" do
				
	  it "should return the page with the next upcoming event" do
	    Page.next_event.should == pages(:home)
	  end
	end
end


describe Page do
  dataset :event_ranges

  describe "#events_in_range" do

    it "should find all events in a given year" do
      Page.events_in_range("2009").should include( pages(:march_first, :march_tenth, :april_first, :august_sixth, :next_christmas) )
    end

    it "should find only events in a given year" do
      Page.events_in_range("2009").should_not include( pages(:last_christmas) )
    end
  
    it "should find all events in a given month" do
      Page.events_in_range("2009/03").should include( pages(:march_first, :march_tenth) )
      Page.events_in_range("2009/04").should include( pages(:april_first) )
      Page.events_in_range("2009/08").should include( pages(:august_sixth) )
    end
  
    it "should find only events of a given month" do
      Page.events_in_range("2009/03").should_not include( pages(:april_first, :august_sixth) )
      Page.events_in_range("2009/04").should_not include( pages(:august_sixth) )
      Page.events_in_range("2009/08").should_not include( pages(:april_first) )
    end
    
    it "should find events on a given day" do
      Page.events_in_range("2009/04/01").should == [pages(:april_first)]
    end
    
    it "should find only events on a given day" do
      Page.events_in_range("2009/04/01").should_not == [pages(:march_first)]
    end
    
    it "should find all events within a given range" do
      Page.events_in_range("2009/03/01","2009/03/10").should == [pages(:march_first, :march_tenth)]
    end
    
  end
  
end