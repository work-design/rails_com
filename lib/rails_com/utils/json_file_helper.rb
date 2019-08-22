module JsonFileHelper
  extend self
  
  def dump(obj, io = default_io)
    JSON.dump(obj, io)
    io.fsync
  end
  
  def default_io
    File.new(path, 'w+')
  end
  
  def path
    Rails.root + 'tmp/share_object.json'
  end
  
end
