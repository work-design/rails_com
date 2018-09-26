
#:nodoc:
set :sidekiq, -> { "#{fetch :bundle_prefix} sidekiq -d" }
set :sidekiqctl, -> { "#{fetch :bundle_prefix} sidekiqctl" }
set :sidekiq_config, -> { "#{fetch :current_path}/config/sidekiq.yml" }
set :sidekiq_pid, -> { "#{fetch :current_path}/tmp/pids/sidekiq.pid" }
set :sidekiq_processes, 2
set :sidekiq_timeout, 10

namespace :sidekiq do

  def for_each_process(&block)
    fetch(:sidekiq_processes).times do |idx|
      if idx == 0
        pid_file = fetch :sidekiq_pid
      else
        pid_file = "#{fetch :sidekiq_pid}-#{idx}"
      end

      yield(pid_file, idx)
    end
  end

  desc 'Quiet sidekiq (stop accepting new work)'
  task quiet: :remote_environment do
    comment 'Quiet sidekiq (stop accepting new work)'
    for_each_process do |pid_file, idx|
      command %{
        if [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1; then
          cd "#{deploy_to}/#{current_path}"
          #{echo_cmd %{#{sidekiqctl} quiet #{pid_file}} }
        else
          echo 'Skip quiet command (no pid file found)'
        fi
      }
    end
  end

  desc 'Stop sidekiq'
  task stop: :remote_environment do
    comment 'Stop sidekiq！'

    for_each_process do |pid_file, _|
      in_path fetch(:current_path) do
        command %{ #{fetch :sidekiqctl} stop #{pid_file} #{fetch :sidekiq_timeout}}
      end
    end
  end

  desc 'Start sidekiq'
  task start: :remote_environment do
    comment 'Start sidekiq！'

    for_each_process do |pid_file, idx|
      in_path fetch(:current_path) do
        command %{ #{fetch :sidekiq} -d -i #{idx} -P #{pid_file} }
      end
    end
  end

  desc 'Restart sidekiq'
  task :restart do
    invoke :'sidekiq:stop'
    invoke :'sidekiq:start'
  end

end