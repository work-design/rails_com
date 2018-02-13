set :puma_cmd, -> { "#{fetch :bundle_prefix} puma -e #{fetch :rails_env}" }
set :pumactl_cmd, -> { "#{fetch :bundle_prefix} pumactl" }
set :puma_socket, -> { "#{fetch :current_path}/tmp/pids/puma.pid" }

namespace :puma do

  desc 'Start puma'
  task start: :remote_environment do
    in_path(fetch(:current_path)) do
      command %{
        if [[ -e #{fetch :puma_socket} ]]
        then
          echo 'Puma is already running!'
        else
          #{fetch :puma_cmd}
        fi
      }
    end
  end

  desc 'Stop puma'
  task stop: :remote_environment do
    in_path(fetch(:current_path)) do
      command %{
        if [[ -e #{fetch :puma_socket} ]]
        then
          #{fetch :pumactl_cmd} stop
        else
          echo 'Puma is not running!'
        fi
      }
    end
  end

  desc 'Restart puma'
  task restart: :remote_environment do
    in_path(fetch(:current_path)) do
      command %{
        if [[ -e #{fetch :puma_socket} ]]
        then
          #{fetch :pumactl_cmd} restart
        else
          echo 'Puma is not running! Start Now!' && #{fetch :puma_cmd}
        fi
      }
    end
  end

  desc 'Restart puma (phased restart)'
  task phased_restart: :remote_environment do
    in_path(fetch(:current_path)) do
      command %{
        if [[ -e #{fetch :puma_socket} ]]
        then
          #{fetch :pumactl_cmd} phased-restart
        else
          echo 'Puma is not running! Start Now!' && #{fetch :puma_cmd}
        fi
      }
    end
  end

end
