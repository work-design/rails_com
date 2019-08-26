
# temp ignore config/webpacker changes
# git update-index --assume-unchanged config/webpacker.yml
# check it works
# git ls-files -v | grep config/webpacker.yml
# recover
# git update-index --no-assume-unchanged config/webpacker.yml
module Webpacker
  class YamlHelper
    attr_reader :yaml, :io

    def initialize(path: 'config/webpacker.yml', export: 'config/webpacker.yml')
      real_path = Rails.root + path
      real_export = Rails.root + export
      
      @yaml = YAML.parse_stream File.read(real_path)
      @io = File.new(real_export, 'a+')
    end
    
    def dump
      io.truncate(0)
      @yaml.yaml io
      io.fsync
    end
    
    def append(env = 'default', key, value)
      a = yaml.children[0].children[0].children
      a_index = a.find_index { |i| i.scalar? && i.value == env }

      b = a[a_index + 1].children
      b_index = b.find_index { |i| i.scalar? && i.value == key }
      
      c = b[b_index + 1]
      if c.sequence?
        c.style = 1  # block style
        c.children << Psych::Nodes::Scalar.new(value)
      end
      
      c
    end
    
  end
end
