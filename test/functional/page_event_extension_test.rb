require File.dirname(__FILE__) + '/../test_helper'

class PageEventExtensionTest < Test::Unit::TestCase
  fixtures :pages
  
  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'page_event'), PageEventExtension.root
    assert_equal 'Page Event', PageEventExtension.extension_name
  end

  def test_events_by_month
    assert_respond_to Page, :events_by_month
		assert_equal(3, Page.events_by_month.size)
		assert_not_equal(Page.find(:all).size, Page.events_by_month.size)
  end

  def test_event_count_by_month
    assert_respond_to Page, :event_count_by_month
		assert_equal(3, Page.event_count_by_month)
		assert_not_equal(Page.find(:all).size, Page.events_by_month)
  end

  def test_next_event
		next_event = pages(:homepage)
    assert_respond_to Page, :next_event
		assert_equal(next_event, Page.next_event)
  end

  def test_upcoming_events
		next_event = pages(:homepage)
    assert_respond_to Page, :upcoming_events
		upcoming_events = Page.upcoming_events
		assert_equal(2, upcoming_events.size)
		assert_equal(next_event, upcoming_events.first)
  end
end
