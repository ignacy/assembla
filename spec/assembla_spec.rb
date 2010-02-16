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

  # TODO I should refactor this so that there's only one find method
  context "filtering tickets" do
    it "should filter tickets by assigned user" do
      mine = @assem.find_assigned_to("Above & Beyond")
      mine.length.should eql(2)
    end

    #TODO find_id should return only one element
    it "should filter tickets by id" do
      with_id = @assem.find_id(841)
      with_id.first.summary.should match /Fix tab order/
    end

    it "should filter tickets by status" do
      test = @assem.find_with_status("Test")
      test.length.should eql(2)
    end

    it "should filter tickets by summary text" do
      se = @assem.find_with_summary("else")
      se.first.summary.should match /Somethign else/
    end

    context "with multiple filters " do
      it "should filter tickets with status and assigned user" do
        a = @assem.find_assigned_with_status("Armin Van B", "Test")
        a.count.should eql(5)
      end      
    end
  end
end
