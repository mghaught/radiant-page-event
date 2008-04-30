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
end
