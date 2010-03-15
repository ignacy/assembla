# This program allows you to use command line to perform
# your typical assembla.com tasks. USing it you can check
# for new tickets, change status, reasign them or create new ones
#
# Author::    Ignacy Moryc  (mailto:imoryc@gmail.com)
# License::   MIT
#
# This is the ticket class responsible for
# describing the ticket object.

class Ticket
  attr_accessor :id, :summary, :status, :assigned_to
  
  def initialize(id, summary, status, assigned_to) #:nodoc:
    self.id = id.to_i
    self.summary = summary
    self.status = status
    self.assigned_to = assigned_to
  end

  def to_s #:nodoc:
    "#{self.id.to_s.center(5)}|#{self.assigned_to.center(18)}|#{self.status.to_s.center(10)}| #{self.summary} \n"
  end
  
end
