# This program allows you to use command line to perform
# your typical assembla.com tasks. USing it you can check
# for new tickets, change status, reasign them or create new ones
#
# Author::    Ignacy Moryc  (mailto:imoryc@gmail.com)
# License::   MIT
#
# This is the main program class


require 'open-uri'
require 'net/http'
require 'rubygems'
require 'hpricot'
require 'patron'
require File.dirname(__FILE__) + '/ticket'
require File.dirname(__FILE__) + '/interpreter'

$:.unshift File.join(File.dirname(__FILE__), *%w[..])

class AssEmBlr

  attr_accessor :page, :parsed, :url, :user, :password

  # This metod requires for the config file to be present
  def initialize
    config = YAML::parse( File.open(File.expand_path("~/.assembla")))
    @url = config["url"].value
    @user = config["user"].value
    @password = config["password"].value
    @me = config["me"].value
    self.page = Hpricot(open(@url, :http_basic_authentication=>[@user, @password]))
    tickets
  end

  # This method parsess all active tickets in your Assembla space 
  def tickets
    all = All.new
    self.parsed = all.evaluate(self.page) 
  end

  def print_tickets
    puts_title_line
    self.parsed.each do |ticket|
      puts ticket.to_s
    end
  end

  def find_assigned_to(to = @me)
    puts_title_line
    ass = Assigned.new
    assigned_to = ass.evaluate(self.parsed, to)
  end

  def find_with_status(status = "New")
    puts_title_line
    st = Status.new
    active = st.evaluate(self.parsed, status)
  end

  def print(tickets)
    tickets.each { |t| puts t.to_s }
  end
  
  def find_id(id)
    puts_title_line
    result = Id.new
    found = result.evaluate(self.parsed, Id)
  end

  # Change ticket state
  def update_ticets_status(id, status)
    sess = Patron::Session.new
    sess.username = @user
    sess.password = @password
    sess.timeout = 10
    sess.base_url = @url.gsub(/https/, "http")
    sess.headers['Accept'] = 'application/xml'
    sess.headers['Content-Type'] = 'application/xml'
    res = sess.put("/#{id}", "<ticket><status type='integer'>#{status}</status></ticket>")
    puts res.body
  end
  
  private

  # This is a helper method for printing table header
  def puts_title_line
    puts 
    puts " ID  |   Assigned to:   |  Status  | Summary "
    puts "---------------------------------------------------------------------------"
  end
  
end
