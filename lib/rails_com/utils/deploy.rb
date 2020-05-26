# frozen_string_literal: true
require 'open3'

module Deploy
  SHARED_DIRS = [
    'log',
    'tmp',
    'storage',
    'node_modules',
    'public/packs',
    'vendor/bundle'
  ].freeze
  SHARED_FILES = [
    'config/database.yml',
    "config/credentials/staging.key"
  ].freeze
  INIT_DIRS = [
    'config',
    'tmp/sockets',
    'tmp/dirs'
  ].freeze
  extend self

  def restart

  end

  def github_hmac(data)
    OpenSSL::HMAC.hexdigest('sha1', RailsCom.config.github_hmac_key, data)
  end

  def shared_paths
    SHARED_DIRS + SHARED_FILES
  end

  def init_shared_paths(root = '../shared')
    SHARED_DIRS.map do |dir|
      `mkdir -p #{root}/#{dir}`
    end
    INIT_DIRS.map do |dir|
      `mkdir #{root}/#{dir}`
    end
    SHARED_FILES.map do |path|
      `touch #{root}/#{path}`
    end
  end

  def ln_shared_paths(root = Dir.pwd)
    shared_paths.map do |path|
      "ln -sf #{root.join('../shared', path)} #{root.join(path)}"
    end
  end

  def prepare_cmds(env = Rails.env, skip_precompile: false)
    r = []
    r << 'git pull'
    r += ln_shared_paths
    r << 'bundle install --without development test --path vendor/bundle --deployment'
    r << "RAILS_ENV=#{env} bundle exec rake webpacker:compile" unless skip_precompile
    r << "RAILS_ENV=#{env} bundle exec rake db:migrate"
    r << 'bundle exec pumactl restart'
    r << 'systemctl --user restart sidekiq'
    r
  end

  def exec_cmds(env = Rails.env, options = {})
    prepare_cmds(env, **options).each do |cmd|
      puts "=====> #{cmd}"
      Open3.popen2e(cmd) do |_, output, thread|
        puts "-----> #{thread.pid}"
        output.each_line do |line|
          puts line
        end
      end
    end
  end

end
