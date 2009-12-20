require 'ass_em_blr'

describe AssEmBlr do

  before(:each) do
    @assem = AssEmBlr.new
    config = YAML::parse( File.open( "config.yml" ) )
  end
  
  context "getting selected link contents" do
    it "should parse requested page from Assembla" do
      @assem.page.should be_kind_of(Hpricot::Doc)
    end
  end

  context "getting tickets to list" do
    it "should print my tickets" do
      pending
      @assem.print_my_tickets.should == /"#{config["me"].value}"/
    end

    it "should print tickets by status" do
      pending "Mess on the results page"
      @assem.print_by_status("Test")
    end

    it "should print tickets by id" do
      pending "Mess on the results page"
      @assem.print_by_id(169)
    end

    it "should print all my active tickets (New|Accepted)" do
      pending "MESS"
      @assem.print_my_active_tickets
    end
    
    
  end
  
  
end
