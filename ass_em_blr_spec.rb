require 'ass_em_blr'

describe AssEmBlr do

  before(:each) do
    @assem = AssEmBlr.new
  end
  
  context "getting selected link contents" do
    it "should parse requested page from Assembla" do
      @assem.page.should be_kind_of(Hpricot::Doc)
    end
  end

  context "getting tickets to list" do
    it "should find all active tickets" do
      pending "Tickets count changes"
      @assem.tickets_count.should eql 88
    end

    it "should print all tickets" do
      pending "Makes huge mess on the result screen"
      @assem.tickets.size.should eql 88
      @assem.print_tickets
    end

    it "should print my tickets" do
      pending "Mess on the results page"
      @assem.print_my_tickets
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
