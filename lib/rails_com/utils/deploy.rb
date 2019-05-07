module Deploy
  extend self

  def restart

  end

  def github_hmac(data)
    OpenSSL::HMAC.hexdigest('sha1', RailsCom.config.github_hmac_key, data)
  end

  def shared_dirs
    [
      'log',
      'tmp',
      'storage',
      'node_modules',
      'public/assets',
      'public/packs',
      'vendor/bundle'
    ]
  end

  def shared_files
    [
      'config/database.yml',
      'config/master.key'
    ]
  end

  def shared_paths
    shared_dirs + shared_files
  end

  def ln_shared_paths
    shared_paths.map do |path|
      [
        "rm -rf #{path}",
        "ln -s #{'../' * path.split('/').size}shared/#{path} ./#{path}"
      ]
    end.flatten
  end

  def shes(env = Rails.env, skip: {})
    skip = skip.with_indifferent_access
    r = []
    r << "git pull"
    r += ln_shared_paths
    r << "bundle install --without development test --path vendor/bundle --deployment"
    r << "RAILS_ENV=#{env} bundle exec rake assets:precompile" if skip[:precompile]
    r << "RAILS_ENV=#{env} bundle exec rake db:migrate"
    r << "bundle exec pumactl restart"
    r
  end

  def works(env = Rails.env, skip: {})
    shes(env, skip: skip).each do |sh|
      puts "doing: #{sh}"
      `#{sh}`
    end
  end

end
