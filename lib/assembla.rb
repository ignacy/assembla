# This program allows you to use command line to perform
# your typical assembla.com tasks. 
#
# Author::    Ignacy Moryc  (mailto:imoryc@gmail.com)
# License::   MIT



require 'open-uri'
require 'net/http'
require 'rubygems'
require 'hpricot'
require File.dirname(__FILE__) + '/ticket'
require File.dirname(__FILE__) + '/interpreter'

$:.unshift File.join(File.dirname(__FILE__), *%w[..])

class AssEmBlr

  attr_accessor :page, :parsed, :url, :user, :password

  def initialize(config_file = "~/.assembla")
    config = YAML::parse( File.open(File.expand_path(config_file)))
    @url      = config["url"].value
    @user     = config["user"].value
    @password = config["password"].value
    @me       = config["me"].value

    # For testing purposes if the url has no HTTP in it we assume
    # that assembla space is saved to a local file
    (@url =~ /http/) ? \
    self.page = Hpricot(open(@url, :http_basic_authentication=>[@user, @password])) \
    : self.page = Hpricot(open(@url))

    tickets
  end

  # This method parsess all active tickets in your Assembla space 
  def tickets
    all = All.new
    self.parsed = all.evaluate(self.page) 
  end

  # Find operates with different arguments:
  # * :id - ticket's id number
  # * :status - The same as Assembla ticket status ["New", "Accepted", "Test", "Fixed", "Invalid"]
  # * :summary - ticket description
  # * :assigned_to - the person to whom the ticket is assigned to
  # Also you can use params in pairs, like this:
  # * :assigned_to and :status
  def find(args)
    if args.length == 1
      return find_id(args[:id]) if (args[:id])
      return find_with_status(args[:status]) if (args[:status])
      return find_with_summary(args[:summary]) if (args[:summary])
      return find_assigned_to(args[:assigned_to]) if (args[:assigned_to])
    elsif args.length == 2
      return find_assigned_and_with_status(args[:assigned_to], args[:status]) if (args[:status] && args[:assigned_to])
    end
  end

  def find_assigned_to(to = @me) #:nodoc:
    ass = AssignedTo.new
    assigned_to = ass.evaluate(self.parsed, to)
  end

  def find_my_active_tickets #:nodoc:
    ass = self.find({ :assigned_to => @me, :status => "New"})
    test = self.find({ :assigned_to => @me, :status => "Test"})
    accepted = self.find({ :assigned_to => @me, :status => "Accepted"})
    ((accepted + ass) - test)
  end
  
  def find_with_status(status = "New") #:nodoc:
    st = Status.new
    active = st.evaluate(self.parsed, status)
  end

  def find_with_summary(text) #:nodoc:
    sum = Summary.new
    summary = sum.evaluate(self.parsed, text)
  end

  # Prints the tickets to STDOUT
  def print(tickets)
    puts_title_line
    tickets.each { |t| puts t.to_s }
  end

  def find_id(id) #:nodoc:
    result = Id.new
    result.evaluate(self.parsed, id).first
  end

  # This function uses OR condition for search
  # I commented it out for now - because I can see
  # no use for it.
  # def find_assigned_or_with_status(to, status)
  #   st = Status.new
  #   as = AssignedTo.new
  #   st.evaluate(self.parsed, status) | as.evaluate(self.parsed, to)
  # end

  def find_assigned_and_with_status(to, status) #:nodoc:
    st = Status.new
    as = AssignedTo.new
    st.evaluate(self.parsed, status) & as.evaluate(self.parsed, to)
  end

  # This method uses Assembla's Ticket REST API
  # http://www.assembla.com/wiki/show/breakoutdocs/Ticket_REST_API
  # to change tickets status.
  # It returns text of http response from Aseembla server.
  def update_tickets_status(id, status)
    status_number = get_id_from_status(status)
    space = @url.gsub(/https:\/\/www\.assembla.com(.+)/, '\1')
    url = space + '/' + id.to_s
    request = Net::HTTP::Put.new(url, initheader = {'Content-Type' => 'application/xml', 'Accept' => 'application/xml'})
    request.body = "<ticket><status type='integer'>#{status_number}</status></ticket>"
    request.basic_auth @user, @password
    Net::HTTP.start("www.assembla.com", 80 ) do |http|
      response = http.request(request)
      puts response      
    end
  end
  
  private

  def get_id_from_status(s) #:nodoc:
    statuses = { "New" => 0,
      "Accepted" => 1,
      "Invalid" => 2,
      "Fixed" => 3,
      "Test" => 4 }
    return statuses[s]
  end
  
  # This is a helper method for printing table header
  def puts_title_line
    puts 
    puts " ID  |   Assigned to:   |  Status  | Summary "
    puts "---------------------------------------------------------------------------"
  end
  
end
