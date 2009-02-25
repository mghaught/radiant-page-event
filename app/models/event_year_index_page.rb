class EventYearIndexPage < Page

  include ArchiveIndexTagsAndMethods

  def breadcrumb
    if request_uri =~ %r{/(\d{4})/?$}
      year = $1 
      Date.new(year.to_i).strftime("%Y")
    else
      super
    end
  end

  def title
    breadcrumb
  end

  class << ArchiveFinder
    def event_year_finder(finder, year)
      new do |method, options|
        start = Time.local(year)
        finish = start.next_year
        add_condition(options, "event_datetime >= ? and event_datetime < ?", start, finish)
        finder.find(method, options)
      end
    end
  end

  tag "archive:children" do |tag|
    year = $1 if request_uri =~ %r{/(\d{4})/?$}
    tag.locals.children = ArchiveFinder.event_year_finder(parent.children, year)
    tag.expand
  end

  tag "archive:unless_children" do |tag|
    year = $1 if request_uri =~ %r{/(\d{4})/?$}
    if ArchiveFinder.event_year_finder(parent.children, year).find(:all).empty?
      tag.expand
    end
  end
end
