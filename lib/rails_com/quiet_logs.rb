module RailsCom
  class QuietLogs

    def initialize(app)
      @app = app
      @assets_regex = %r(\A/{0,2}(#{RailsCom.config.quiet_logs.join('|')}))
    end

    def call(env)
      if env['PATH_INFO'] =~ @assets_regex
        Rails.logger.debug "Silenced: #{env['PATH_INFO']}"
        Rails.logger.silence { @app.call(env) }
      else
        Rails.logger.debug unless Rails.env.development?
        @app.call(env)
      end
    end

  end
end
