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
    'tmp/sockets',
    'tmp/dirs',
    'config/credentials'
  ].freeze
  extend self

  def restart
  end

  def github_hmac(data)
    OpenSSL::HMAC.hexdigest('sha1', RailsCom.config.github_hmac_key, data)
  end

  def shared_paths(_env)
    SHARED_DIRS + SHARED_FILES
  end

  def init_shared_paths(root = Pathname.pwd.join('../shared'))
    dirs = []
    dirs += SHARED_DIRS.map { |dir| root.join(dir) }
    dirs += INIT_DIRS.map { |dir| root.join(dir) }
    FileUtils.mkdir_p dirs

    SHARED_FILES.map do |path|
      `touch #{root.join(path)}`
    end
  end

  def ln_shared_paths(env, root = Pathname.pwd)
    shared_paths(env).map do |path|
      "ln -Tsf #{root.join('../shared', path)} #{root.join(path)}"
    end
  end

  def prepare_cmds(env, skip_precompile: false)
    r = []
    r << 'git pull'
    r += ln_shared_paths(env)
    r << 'bundle install --without development test --path vendor/bundle --deployment'
    r << "RAILS_ENV=#{env} bundle exec rake webpacker:compile" unless skip_precompile
    r << "RAILS_ENV=#{env} bundle exec rake db:migrate"
    r << 'bundle exec pumactl restart'
    r
  end

  def exec_cmds(env, added_cmds: [], **options)
    cmds = prepare_cmds(env, **options)
    cmds += Array(added_cmds)
    cmds.each do |cmd|
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
