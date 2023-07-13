# frozen_string_literal: true

require 'open3'
require 'optparse'
require 'pathname'
require 'logger'

module Deploy
  MOVED_DIRS = [
    'log',
    'tmp',
  ]
  SHARED_DIRS = [
    'public/assets',
    'public/fonts',
    'vendor/bundle'
  ].freeze
  SHARED_FILES = [
    'config/credentials/production.key'
  ].freeze
  INIT_DIRS = [
    'tmp/sockets',
    'tmp/pids',
    'config/credentials'
  ].freeze
  extend self

  def restart
    exec_cmd('bundle exec pumactl restart')
  end

  def github_hmac(data)
    OpenSSL::HMAC.hexdigest('sha1', RailsCom.config.github_hmac_key, data)
  end

  def init_shared_paths(root = Pathname.pwd.join('../shared'))
    dirs = []
    dirs += MOVED_DIRS.map { |dir| root.join(dir) }
    dirs += SHARED_DIRS.map { |dir| root.join(dir) }
    dirs += INIT_DIRS.map { |dir| root.join(dir) }
    FileUtils.mkdir_p dirs

    SHARED_FILES.map do |path|
      `touch #{root.join(path)}`
    end
  end

  def ln_shared_paths(root = Pathname.pwd)
    cmds = []
    cmds << 'bundle config set --local deployment true'
    cmds << 'bundle config set --local path vendor/bundle'
    cmds << 'bundle config set --local without development test'
    cmds += MOVED_DIRS.map do |path|
      "rm -rf #{root.join(path)}"
    end
    cmds += (MOVED_DIRS + SHARED_DIRS).map do |path|
      "ln -Tsfv #{root.join('../shared', path)} #{root.join(path)}"
    end
    cmds += SHARED_FILES.map do |path|
      "ln -Tsfv #{root.join('../shared', path)} #{root.join(path)}"
    end
    cmds.each do |cmd|
      exec_cmd(cmd)
    end
  end

  def exec_cmds(env = 'production', added_cmds: [])
    start_at = Time.now
    logger.debug "Deploy at #{start_at}"
    cmds = [
      'whoami',
      'git pull',#  --recurse-submodules
      'bundle install'
    ]
    cmds << "RAILS_ENV=#{env} bundle exec rake db:migrate"
    cmds << 'bundle exec pumactl restart'
    cmds += Array(added_cmds)
    cmds.each do |cmd|
      exec_cmd(cmd)
    end
    finish_at = Time.now
    logger.debug "Deploy finished at #{finish_at}, used: #{finish_at - start_at}s"
  end

  def exec_cmd(cmd)
    Open3.popen2e(cmd) do |_, output, thread|
      logger.debug "\e[35m  #{cmd} (PID: #{thread.pid})  \e[0m"
      output.each_line do |line|
        logger.debug "  #{line.chomp}"
      end
      puts "\n"
    end
  end

  def logger
    if defined? Rails
      Rails.logger
    else
      Logger.new $stdout
    end
  end

end

options = { env: 'production' }
OptionParser.new do |opts|
  opts.on('-e ENV') do |v|
    options[:env] = v
  end
  opts.on('-C') do |v|
    puts "--------->#{v}"
  end
end.parse!
