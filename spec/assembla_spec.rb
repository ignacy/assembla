require File.dirname(__FILE__) + '/../lib/assembla'

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

  # TODO need some test here
end
