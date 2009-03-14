class EventArchivePage < ArchivePage
  def child_url(child)
    date = child.event_datetime_start || Time.now
    if child.virtual?
      clean_url "#{ url }/#{ child.slug }"
    else
      clean_url "#{ url }/#{ date.strftime '%Y/%m/%d' }/#{ child.slug }"
    end
  end

  def find_by_url(url, live = true, clean = false)
    url = clean_url(url) if clean
    if url =~ %r{^#{ self.url }(\d{4})(?:/(\d{2})(?:/(\d{2}))?)?/?$}
      year, month, day = $1, $2, $3
      children.find_by_class_name(
        case
        when day
          'EventArchiveDayIndexPage'
        when month
          'EventMonthIndexPage'
        else
          'EventArchiveYearIndexPage'
        end
      )
    elsif url =~ %r{^#{ self.url }(fall|spring)/?$}
      children.find_by_class_name('EventSeasonIndexPage')
    else
      super
    end
  end
end
