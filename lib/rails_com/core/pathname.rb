class Pathname
  
  # like present? and presence
  # if exist? return self
  def existence
    self if exist?
  end
  
end
