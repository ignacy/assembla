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

class Status < Expression
  def evaluate(tickets, status)
    result = []
    tickets.each do |t|
      result.push(t) if t.status == status
    end
    result
  end
end

class Id < Expression
  def evaluate(tickets, id)
    result = []
    tickets.each do |t|
      result.push(t) if t.id == id
    end
    result
  end
end

class AssignedTo < Expression
  def evaluate(tickets, to)
    result = []
    tickets.each do |t|
      result.push(t) if t.assigned_to == to
    end
    result
  end
end
