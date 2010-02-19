
class PageEventExtension < Radiant::Extension
  version "0.4"
  description "Allows you to add event dates to your pages that can be viewed on a site-wide calendar"
  url "http://github.com/mghaught/radiant-page-event/tree/master"
  
  define_routes do |map|
    map.with_options(:controller => 'page_events', :action => "index") do |e|
      e.events  'admin/page_events/:year/:month', :requirements => { :year => /\d+/, :month => /\d+/ }
      e.events  'admin/page_events/:year',        :requirements => { :year => /\d+/ }
    end
    map.connect 'admin/page_events/:action', :controller => 'page_events'
  end

  def activate
    EventArchivePage
    EventMonthIndexPage
    EventSeasonIndexPage
		Page.send :include, PageEvent::PageExtensions
		Page.send :include, PageEventTags
    admin.page.edit.add :parts_bottom, "edit_page_event", :before => 'edit_layout_and_type'
    admin.tabs.add "Events", "/admin/page_events", :after => "Pages", :visibility => [:all]
  end
  
end