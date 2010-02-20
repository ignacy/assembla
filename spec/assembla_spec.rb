require File.dirname(__FILE__) + '/../lib/assembla'

describe AssEmBlr do

  before(:all) do
    @assem = AssEmBlr.new(File.dirname(__FILE__) + '/test_config.yml')
  end
  
  context "getting selected link contents" do
    it "should parse requested page from Assembla" do
      @assem.page.should be_kind_of(Hpricot::Doc)
    end
    it "should parse all tickets" do
      @assem.parsed.length.should eql(6)
    end
  end

  it "should find status number code properly" do
    @assem.send(:get_id_from_status, "Fixed").should eql(3)
    @assem.send(:get_id_from_status, "Invalid").should eql(2)
  end
  
  context "searching for tickets" do
    it "should use 'Assiged To' filter" do
      pending("Extend the find method")
      mine = @assem.find({:assigned_to => "Above & Beyond"})
      mine.length.should eql(2)
    end
    
    it "should filter tickets by assigned user" do
      mine = @assem.find_assigned_to("Above & Beyond")
      mine.length.should eql(2)
    end
    
    it "should filter tickets by id" do
      with_id = @assem.find({:id => 841})
      with_id.summary.should match /Fix tab order/
    end

    it "should filter tickets by status" do
      test = @assem.find({:status => "Test"})
      test.length.should eql(2)
    end

    it "should filter tickets by summary text" do
      se = @assem.find({:summary => "else"})
      se.first.summary.should match /Somethign else/
    end

    context "with multiple filters " do
      it "should find with status OR assigned to" do
        pending()
        a = @assem.find({:status => "Test", :assigned_to => "Armin Van B"})
        a.count.should eql(5)
      end
      
      it "should filter tickets with status or assigned user" do
        a = @assem.find_assigned_or_with_status("Armin Van B", "Test")
        a.count.should eql(5)
      end

      it "should filter tickets with status and assigned user" do
        a = @assem.find_assigned_and_with_status("Armin Van B", "Test")
        a.count.should eql(1)
      end

      it "should find tickets with status AND assigned user" do
        pending
        a = @assem.find({:assigned_to => "Armin Van B", :status => "Test"})
        a.count.should eql(1)
      end
      
    end
  end
end
