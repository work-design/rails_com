set :puma_cmd, -> { "#{fetch :bundle_more_prefix} puma -e #{fetch :rails_env}" }
set :pumactl_cmd, -> { "#{fetch :bundle_more_prefix} pumactl" }
set :puma_socket, -> { "#{fetch :current_path}/tmp/pids/puma.pid" }

namespace :puma do

  desc 'Start puma'
  task start: :environment do
    in_path fetch(:current_path) do
      command "#{fetch :puma_cmd}"
    end
  end

  desc 'Stop puma'
  task stop: :environment do
    pumactl_command 'stop'
  end

  desc 'Restart puma'
  task restart: :environment do
    pumactl_command 'restart'
  end

  desc 'Restart puma (phased restart)'
  task phased_restart: :environment do
    pumactl_command 'phased-restart'
  end

  def pumactl_command(name)
    in_path fetch(:current_path) do
      command %{
        if [ -e #{fetch :puma_socket} ]
        then
          #{fetch :pumactl_cmd} #{name}
        else
          echo 'Puma is not running!';
        fi
      }
    end
  end
end
