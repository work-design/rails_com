require 'pry'
require 'bundler/setup'  # for require sidekiq & puma from rails_com

require 'mina/git'
require 'mina/rails'
require 'mina/rvm'

require 'mina/whenever'
require 'mina/sidekiq'
require 'mina/puma'


if ENV['on'].nil?
  if ENV['to']
    set :branch, ENV['to']
  else
    set :branch, 'staging'
  end
  require File.expand_path('../deploy/staging.rb', __FILE__)
else
  require File.expand_path("../deploy/#{ENV['on']}.rb", __FILE__)
end

set :repository, 'git@github.com'
set :forward_agent, true
set :bundle_more_prefix, -> { "BUNDLE_GEMFILE=#{fetch(:current_path) + '/Gemfile'} #{fetch :bundle_prefix}" }

set :shared_dirs, fetch(:shared_dirs) + [
  'tmp',
  'public/uploads',
  'public/system'
]

set :shared_files, [
  'config/database.yml',
  'config/secrets.yml'
]

task :local_environment do
end

task :remote_environment do
  invoke :'rvm:use', 'ruby-2.4.3@default'
end

task :setup do
  command %{ mkdir -p #{fetch :shared_path}/log }
  command %{ mkdir -p #{fetch :shared_path}/config }
  command %{ mkdir -p #{fetch :shared_path}/tmp/sockets }
  command %{ mkdir -p #{fetch :shared_path}/tmp/pids }
binding.pry
  command %{ touch #{fetch :shared_path}/config/database.yml }
  command %{ touch #{fetch :shared_path}/config/elasticsearch.yml }
  command %{ touch #{fetch :shared_path}/config/secrets.yml }
  command %{ touch #{fetch :shared_path}/tmp/sockets/puma.state }
  command %{ touch #{fetch :shared_path}/tmp/pids/puma.pid }
  comment %{ Be sure to edit #{fetch :shared_path}/config/database.yml and secrets.yml }
end

desc 'Deploys the current version to the server.'
task deploy: :remote_environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:assets_precompile'
    invoke :'rails:db_migrate'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'puma:restart'
      invoke :'sidekiq:restart'
      invoke :'whenever:update'
    end
  end
end

desc 'Deploy to multiple hosts'
task :multi_deploy do
  ['staging'].each do |env|
    require File.expand_path("../deploy/#{env}.rb", __FILE__)
    invoke 'deploy'
  end
end
