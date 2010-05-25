# This program allows you to use command line to perform
# your typical assembla.com tasks. USing it you can check
# for new tickets, change status, reasign them or create new ones
#
# Author::    Ignacy Moryc  (mailto:imoryc@gmail.com)
# License::   MIT
#
# This is the ticket class responsible for
# describing the ticket object.

class Space
  attr_accessor :id, :name, :description

  def initialize(id, name, description)
    self.id = id
    self.name = name
    self.description = description
  end

  def to_s #:nodoc:
    "Space name #{name}, space description #{description}"
  end

end

    
    
