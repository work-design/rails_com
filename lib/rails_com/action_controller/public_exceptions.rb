module RailsCom::PublicExceptions
  def call(env)
    @exp = env['action_dispatch.exception']
    super
  end

  private

  def render(status, content_type, body)
    error = { class: @exp.class.inspect }
    if @exp.respond_to?(:id)
      error.merge! id: @exp.id
    end
    message = if @exp.respond_to?(:record)
                @exp.record.error_text
              else
                RailsCom.config.default_error_message.presence || @exp.message
              end
    body = {
      error: error,
      message: message
    }

    super
  end
end

ActionDispatch::PublicExceptions.prepend RailsCom::PublicExceptions
