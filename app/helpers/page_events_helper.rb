module PageEventsHelper
  
  def month_with_year(date)
    if Time.now.year == date.year
      date.strftime("%B")
    else
      date.strftime("%B, %Y")
    end
  end
  
end