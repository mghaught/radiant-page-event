class EventArchivePage < ArchivePage
  def child_url(child)
    date = child.event_datetime || Time.now
    clean_url "#{ url }/#{ date.strftime '%Y/%m/%d' }/#{ child.slug }"
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
    else
      super
    end
  end
end