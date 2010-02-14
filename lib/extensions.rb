# Useful functionality that didn't belong anywhere else
class Object
  def returning(value)
    yield(value)
    value
  end
end
