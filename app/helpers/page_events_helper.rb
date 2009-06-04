module PageEventsHelper
  
  def month_with_year(date)
    if Time.now.year == date.year
      date.strftime("%B")
    else
      date.strftime("%B, %Y")
    end
  end
  
  def finishing_time(finish, start)
    if finish.day == start.day and finish.month == start.month and finish.year == start.year
      finish.strftime("%I:%M %p")
    else
      if finish.year == start.year
        finish.strftime("%d %b, %I:%M %p")
      else
        finish.strftime("%d %b %Y, %I:%M %p")
      end
    end
  end
  
end