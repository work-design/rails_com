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
      'public/packs'
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
        "ln -s ../../shared/#{path} ./#{path}"
      ]
    end.flatten
  end

  def shes(env = Rails.env)
    [
      "git pull",
      ln_shared_paths,
      "bundle install",
      "RAILS_ENV=#{env} bundle exec rake assets:precompile",
      "RAILS_ENV=#{env} bundle exec rake db:migrate",
      "bundle exec pumactl restart"
    ].flatten
  end

  def works(env = Rails.env)
    shes(env).each do |sh|
      `#{sh}`
    end
  end

end
