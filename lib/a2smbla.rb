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

class AssEmBlr

  attr_accessor :page, :parsed, :url, :user, :password

  # This metod requires for the config file to be present
  def initialize
    config = YAML::parse( File.open( "config.yml" ) )
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

  def print_my_tickets
    puts_title_line
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
  
  
  def puts_title_line
    puts 
    puts " ID  |   Assigned to:   |  Status  | Summary "
    puts "---------------------------------------------------------------------------"
  end
  
end







class Expression
end

class All < Expression
  def evaluate(page)
    result = []
    (page/"tr.ticket_row").each do |ticket|
      result.push Ticket.new((ticket/"td.number/a").first.inner_html,
                                  (ticket/"td.summary/a").first.inner_html,
                                  (ticket/"td.status/a").first.inner_html,
                                  (ticket/"td.assigned_to_id/a").first.inner_html)
    end
    result
  end
end




if __FILE__ == $0
  @assem = AssEmBlr.new
  @assem.print_my_active_tickets
  @assem.update_ticets_status(314, 0)
end
