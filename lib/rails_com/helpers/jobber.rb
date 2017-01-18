module Jobber
  extend self

  # deliver job
  def deliver(job, arguments, options={})
    msg = job_data(job, arguments, at: options[:at])

    redis_pool.with do |conn|
      conn.lpush("#{@namespace}:queue:default", JSON.dump(msg))
    end
  end

  def job_data(job, args, at: nil)
    {
      class: 'JobWrapper',
      wrapped: job,
      queue: config['queue'],
      args: {
        job_class: job,
        job_id: SecureRandom.uuid,
        queue_name: config['queue'],
        priority: nil,
        arguments: args,
        locale: 'en'
      },
      at: at
    }
  end

  def redis_pool
    @redis_pool ||= ConnectionPool.new(size: 5, timeout: 5) { Redis.new(url: config['url']) }
  end

  def config
    @config ||= Rails.application.config_for('jobber')
  end

  def redis_stat
    result = redis_pool.with do |conn|
      conn.pipelined do
        conn.get('stat:processed'.freeze)
        conn.get('stat:failed'.freeze)
        conn.zcard('schedule'.freeze)
        conn.zcard('retry'.freeze)
        conn.zcard('dead'.freeze)
        conn.scard('processes'.freeze)
        conn.lrange('queue:default'.freeze, -1, -1)
        conn.smembers('processes'.freeze)
        conn.smembers('queues'.freeze)
      end
    end
    result
  end

end