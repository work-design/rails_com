# temp ignore config/webpacker changes
# git update-index --assume-unchanged config/webpacker.yml
# check it works
# git ls-files -v | grep config/webpacker.yml
# recover
# git update-index --no-assume-unchanged config/webpacker.yml
module Webpacker
  class YamlHelper

    def initialize(path: 'config/webpacker.yml', export: 'config/webpacker.yml')
      real_path = Rails.root + path
      real_export = Rails.root + export
      
      @yaml = YAML.parse_stream File.read(real_path)
      @content = @yaml.children[0].children[0].children
      @parsed = @yaml.to_ruby[0]
      @io = File.new(real_export, 'a+')
    end
    
    def dump
      @io.truncate(0)
      @yaml.yaml @io
      @io.fsync
      @io.close
    end
    
    def append(env = 'default', key, value)
      return if Array(@parsed.dig(env, key)).include? value
      env_index = @content.find_index { |i| i.scalar? && i.value == env }

      env_content = @content[env_index + 1].children
      key_index = env_content.find_index { |i| i.scalar? && i.value == key }
      
      value_content = env_content[key_index + 1]
      if value_content.sequence?
        value_content.style = 1  # block style
        value_content.children << Psych::Nodes::Scalar.new(value)
      end

      value_content
    end
    
  end
end
