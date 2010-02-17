require File.dirname(__FILE__) + '/extensions'

class Expression

  # def |(other)
  #   Or.new(self, other)
  # end

  # def &(other)
  #   And.new(self, other)
  # end
  
end

class All < Expression
  def evaluate(page)
    returning result = [] do 
      (page/"tr.ticket_row").each do |ticket|
        result.push Ticket.new((ticket/"td.number/a").first.inner_html,
                               (ticket/"td.summary/a").first.inner_html,
                               (ticket/"td.status/a").first.inner_html,
                               (ticket/"td.assigned_to_id/a").first.inner_html)
      end
    end
  end
end

class Status < Expression
  def evaluate(tickets, status)
    returning result = [] do
      tickets.each { |t| result.push(t) if t.status == status }
    end
  end
end

class Id < Expression
  def evaluate(tickets, id)
    returning result = [] do
      tickets.each { |t| result.push(t) if t.id == id }
    end
  end
end

class AssignedTo < Expression
  def evaluate(tickets, to)
    returning result = [] do
      tickets.each { |t| result.push(t) if t.assigned_to == to }
    end
  end
end

class Summary < Expression
  def evaluate(tickets, text)
    returning result = [] do
      tickets.each { |t| result.push(t) if t.summary.match(text) }
    end
  end
end

# class Or < Expression
#  def initialize(tickets1, tickets2)
#    (tickets1 + tickets).sort.uniq
#  end
# end

# class And < Expression
#  def initialize(tickets1, tickets2)
#    (tickets1 + tickets).sort.uniq
#  end
# end
