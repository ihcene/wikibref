class Array
  def complete(needed_length)
    return self + Array.new( needed_length - self.length, nil ) if self.length < needed_length
    self
  end
end

class Object
  def or(other_object)
    return other_object if self.blank?
    self
  end
end