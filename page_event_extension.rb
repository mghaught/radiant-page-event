
class PageEventExtension < Radiant::Extension
  version "0.3"
  description "Allows you to add event dates to your pages that can be viewed on a site-wide calendar"
  url "http://github.com/mghaught/radiant-page-event/tree/master"
  
  define_routes do |map|
    map.connect 'admin/page_events/:action', :controller => 'page_events'
  end

  def activate
    EventArchivePage
    EventMonthIndexPage
    EventSeasonIndexPage
		Page.send :include, PageEvent::PageExtensions
		Page.send :include, PageEventTags
		admin.page.edit.add :layout_row, "edit_page_event"
    admin.tabs.add "Page Events", "/admin/page_events", :after => "Pages", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Page Events"
  end
end