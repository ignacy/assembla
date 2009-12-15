require 'open-uri'
require 'rubygems'
require 'hpricot'

class AssEmBlr

  attr_accessor :page, :parsed
  
  def initialize
    config = YAML::parse( File.open( "config.yml" ) )
    url = config["url"].value
    user = config["user"].value
    password = config["password"].value
    @me = config["me"].value
    self.page = Hpricot(open(url, :http_basic_authentication=>[user, password]))
    tickets
  end

  def tickets_count
    (page/"tr.ticket_row").size
  end

  def tickets
    self.parsed = []
    (page/"tr.ticket_row").each do |ticket|
      self.parsed.push Ticket.new((ticket/"td.number/a").first.inner_html,
                                  (ticket/"td.summary/a").first.inner_html,
                                  (ticket/"td.status/a").first.inner_html,
                                  (ticket/"td.assigned_to_id/a").first.inner_html)
    end
  end

  def print_tickets
    self.parsed.each do |ticket|
      puts ticket.to_s
    end
  end

  def print_my_tickets
    self.parsed.each do |ticket|
      if ticket.assigned_to == @me
        puts ticket.to_s
      end
    end
  end

  def print_my_active_tickets
    puts_title_line
    self.parsed.each do |ticket|
      if ticket.assigned_to == @me && (ticket.status == "New" || ticket.status == "Accepted")
        puts ticket.to_s
      end
    end
  end
  
  def print_by_status(status = "New")
    self.parsed.each do |ticket|
      if ticket.status == status
        puts ticket.to_s
      end
    end
  end

  def print_by_id(id)
    self.parsed.each do |ticket|
      if ticket.id == id
        puts ticket.to_s
      end
    end
  end

  def puts_title_line
    puts 
    puts " ID  |   Assigned to:   |  Status  | Summary "
    puts "---------------------------------------------------------------------------"
  end
  
end

class Ticket
  attr_accessor :id, :summary, :status, :assigned_to
  
  def initialize(id, summary, status, assigned_to)
    self.id = id
    self.summary = summary
    self.status = status
    self.assigned_to = assigned_to
  end

  def to_s
    "#{self.id.to_s.center(5)}|#{self.assigned_to.center(18)}|#{self.status.to_s.center(10)}| #{self.summary} \n"
  end
  
end

if __FILE__ == $0
  @assem = AssEmBlr.new
  @assem.print_my_active_tickets
end
