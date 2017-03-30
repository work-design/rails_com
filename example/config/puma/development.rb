dir = ENV['PWD']
sdir = ENV['PWD']

port 3000
threads 5, 64
environment 'development'
directory dir
daemonize false

bind "unix://#{File.expand_path('tmp/sockets/puma.sock', sdir)}"
pidfile "#{File.expand_path('tmp/pids/puma.pid', sdir)}"
state_path "#{File.expand_path('tmp/sockets/puma.state', sdir)}"
activate_control_app "unix://#{File.expand_path('tmp/sockets/pumactl.sock', sdir)}"

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

on_restart do
  puts '- * - On restart - * -'
  puts 'pidfile: '
  puts @options[:pidfile]
  puts 'binds: '
  puts @options[:binds]
  puts 'control_url: '
  puts @options[:control_url]
  puts '- * - * - * -'
end

