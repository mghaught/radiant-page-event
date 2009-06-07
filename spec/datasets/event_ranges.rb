class EventRanges < Dataset::Base
  uses :home_page
  
  def load
    create_page "Last Christmas", :event_datetime_start => Time.local(2008,12,25).to_s(:db)
    create_page "March first",    :event_datetime_start => Time.local(2009,3,1).to_s(:db)
    create_page "March tenth",    :event_datetime_start => Time.local(2009,3,10).to_s(:db)
    create_page "April first",    :event_datetime_start => Time.local(2009,4,1).to_s(:db)
    create_page "August sixth",   :event_datetime_start => Time.local(2009,8,6).to_s(:db)
    create_page "Next Christmas", :event_datetime_start => Time.local(2009,12,25).to_s(:db)
  end
end