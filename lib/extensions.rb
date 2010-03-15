# Useful functionality that didn't belong anywhere else
class Object
  # Borowed from Rails.. http://api.rubyonrails.org/classes/Object.html#M000289
  def returning(value)
    yield(value)
    value
  end
end
