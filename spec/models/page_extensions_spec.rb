require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
	scenario :pages
	
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
		
		before(:each) do
		  create_page "Another event", :event_datetime => (Time.now.at_beginning_of_month.next_month - 4.minutes).to_s(:db)
		end
		
	  it "should return the pages for the next 3 upcoming events" do
			Page.upcoming_events.should have(3).items
	  end
	
		it "should return the home page, the next event, as the first page" do
		  Page.upcoming_events.first.should == pages(:home)
		end
		
		describe "with more upcoming events" do
			
			before(:each) do
			  create_page "Yet another event", :event_datetime => (Time.now.at_beginning_of_month.next_month - 3.minutes).to_s(:db)
				create_page "Final event", :event_datetime => (Time.now.at_beginning_of_month.next_month - 1.minutes).to_s(:db)
			end
			
		  it "should return only return 3 events, even if there are more" do
				Page.upcoming_events.should have(3).items
		  end
		
			it "should allow more than 3 events with a different argument value" do
			  Page.upcoming_events(5).should have(5).items
			end
		end

	end

	describe "#next_event" do
				
	  it "should return the page with the next upcoming event" do
	    Page.next_event.should == pages(:home)
	  end
	end
end

