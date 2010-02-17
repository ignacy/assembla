# This program allows you to use command line to perform
# your typical assembla.com tasks. 
#
# Author::    Ignacy Moryc  (mailto:imoryc@gmail.com)
# License::   MIT
#
# This is the main program class


require 'open-uri'
require 'net/http'
require 'rubygems'
require 'hpricot'
require File.dirname(__FILE__) + '/ticket'
require File.dirname(__FILE__) + '/interpreter'

$:.unshift File.join(File.dirname(__FILE__), *%w[..])

class AssEmBlr

  attr_accessor :page, :parsed, :url, :user, :password

  # This metod requires for the config file to be present
  def initialize(config_file = "~/.assembla")
    config = YAML::parse( File.open(File.expand_path(config_file)))
    @url = config["url"].value
    @user = config["user"].value
    @password = config["password"].value
    @me = config["me"].value

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

  def find(args)
    return find_id(args[:id]) if (args[:id])
    return find_with_status(args[:status]) if (args[:status])
    return find_with_summary(args[:summary]) if (args[:summary])
  end
  
  def print_tickets
    puts_title_line
    self.parsed.each do |ticket|
      puts ticket.to_s
    end
  end

  def find_assigned_to(to = @me)
    ass = AssignedTo.new
    assigned_to = ass.evaluate(self.parsed, to)
  end

  def find_my_active_tickets
    ass = find_assigned_to(@me)
    new = find_with_status("New")
    test = find_with_status("Test")
    accepted = find_with_status("Accepted")
    ((accepted + new + ass) - test).uniq
  end
  
  def find_with_status(status = "New")
    st = Status.new
    active = st.evaluate(self.parsed, status)
  end

  def find_with_summary(text)
    sum = Summary.new
    summary = sum.evaluate(self.parsed, text)
  end
  
  def print(tickets)
    puts_title_line
    tickets.each { |t| puts t.to_s }
  end

  def find_id(id)
    result = Id.new
    result.evaluate(self.parsed, id)
  end

  def find_assigned_or_with_status(to, status)
    st = Status.new
    as = AssignedTo.new
    st.evaluate(self.parsed, status) | as.evaluate(self.parsed, to)
  end

  def find_assigned_and_with_status(to, status)
    st = Status.new
    as = AssignedTo.new
    st.evaluate(self.parsed, status) & as.evaluate(self.parsed, to)
  end
  
  def update_ticket_to_new(id)
    space = @url.gsub(/https:\/\/www\.assembla.com(.+)/, '\1')
    url = space + '/' + id.to_s
    request = Net::HTTP::Put.new(url, initheader = {'Content-Type' => 'application/xml', 'Accept' => 'application/xml'})
    request.body = "<ticket><status type='integer'>0</status></ticket>"
    request.basic_auth @user, @password
    Net::HTTP.start("www.assembla.com", 80 ) do |http|
      response = http.request(request)
      puts response      
    end
  end
  
  private

  # This is a helper method for printing table header
  def puts_title_line
    puts 
    puts " ID  |   Assigned to:   |  Status  | Summary "
    puts "---------------------------------------------------------------------------"
  end
  
end
