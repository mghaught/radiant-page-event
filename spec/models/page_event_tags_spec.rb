require File.dirname(__FILE__) + '/../spec_helper'

describe "<r:events>" do
  dataset :event_ranges
  
  before(:each) do
    @page = pages(:home)
  end
  
  it "should render contents" do
    @page.should render('<r:events>Whatever</r:events>').as('Whatever')
  end
  
  describe "in_range" do
    it "should render contents" do
      @page.should render('<r:events:in_range>Whatever</r:events:in_range>').as('Whatever')
    end

    it "should render contents for each event in month" do
      @page.should render(%Q{<r:events:in_range:each start="2009/03">A </r:events:in_range:each>}).
        as('A A ')
    end

    it "should render contents for each event in year" do
      @page.should render(%Q{<r:events:in_range:each start="2009">A </r:events:in_range:each>}).
        as('A A A A A ')
    end

    it "should render contents for each event in date range" do
      @page.should render(%Q{<r:events:in_range:each start="2009/03/01" finish="2009/03/10">A </r:events:in_range:each>}).
        as('A A ')
    end
    
    it "should render title of each event in specified time" do
      @page.should render(%Q{<r:events:in_range:each start="2009/03"><r:title/> </r:events:in_range:each>}).
        as('March first March tenth ')
    end
    
    
  end
  
end

