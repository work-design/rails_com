module Webpacker
  module YamlHelper
    extend self
    
    def dump(obj, io = default_io)
      YAML.dump(obj, io)
      io.fsync
    end
    
    def resolved_paths_concat(ary = [])
      r = YAML.load_file(path)
      r['production']['resolved_paths'] += ary
      dump(r)
      r
    end
    
    def default_io
      File.new(path, 'w+')
    end
    
    def path
      Rails.root + 'config/webpacker.yml'
    end
    
  end
end
