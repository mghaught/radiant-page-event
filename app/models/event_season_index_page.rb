class EventSeasonIndexPage < Page

  include ArchiveIndexTagsAndMethods

  SEASON_MONTHS = {
    "spring" => [1, 2, 3, 4, 5, 6],
    "fall" => [9, 10, 11, 12]
  }


  def breadcrumb
    if request_uri =~ %r{/(fall|spring)/?$}
      $1.capitalize
    else
      super
    end
  end

  def title
    breadcrumb
  end

  class << ArchiveFinder
    def event_season_finder(finder, season)
      new do |method, options|
        # Only tested against MySQL
        add_condition(options, "MONTH(event_datetime_start) IN (?)", SEASON_MONTHS[season])
        finder.find(method, options)
      end
    end
  end

  tag "archive:children" do |tag|
    season = $1 if request_uri =~ %r{/(fall|spring)/?$}
    tag.locals.children = ArchiveFinder.event_season_finder(parent.children, season)
    tag.expand
  end

  tag "archive:unless_children" do |tag|
    season = $1 if request_uri =~ %r{/(fall|spring)/?$}
    if ArchiveFinder.event_season_finder(parent.children, season).find(:all).empty?
      tag.expand
    end
  end

  tag "archive:season" do |tag|
    breadcrumb
  end
end