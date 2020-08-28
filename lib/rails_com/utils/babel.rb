# frozen_string_literal: true

require 'tempfile'

module Babel
  extend self

  def script_path
    @app_path = File.expand_path('.', Dir.pwd)
    node_modules_bin_path = ENV['WEBPACKER_NODE_MODULES_BIN_PATH'] || `yarn bin`.chomp
    babel_config = File.join(@app_path, '.babelrc')

    "#{node_modules_bin_path}/babel --config-file #{babel_config}"
  end

  def context(file)
    `#{script_path} #{file}`
  end

  def transform(code, _options = {})
    tmpfile = write_to_tempfile(code)

    begin
      r = context(tmpfile)
    ensure
      File.unlink(tmpfile)
    end

    r
  end

  def write_to_tempfile(contents)
    tmpfile = Tempfile.open(%w[babel js])
    tmpfile.write(contents)
    r = tmpfile.path
    tmpfile.close
    r
  end
end
