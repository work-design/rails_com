# frozen_string_literal: true

module CommonApi
  attr_reader :app, :client

  def initialize(app)
    @app = app
    @client = HTTPX.with(
      ssl: {
        verify_mode: OpenSSL::SSL::VERIFY_NONE
      },
      headers: {
        'Accept' => 'application/json'
      }
    )
  end

  def get(path, params: {}, headers: {}, origin: nil, debug: nil)
    with_options = { origin: origin }
    with_options.merge! debug: STDERR, debug_level: 2 if debug

    with_access_token(params) do |with_token_params|
      response = @client.with_headers(headers).with(with_options).get(path, params: with_token_params)
      debug ? response : parse_response(response)
    end
  end

  def post(path, params: {}, headers: {}, origin: nil, debug: nil, **payload)
    with_options = { origin: origin }
    with_options.merge! debug: STDERR, debug_level: 2 if debug

    with_access_token(params) do |with_token_params|
      with_token_params.merge! debug: 1 if debug
      response = @client.with_headers(headers).with(with_options).post(path, params: with_token_params, json: payload)
      debug ? response : parse_response(response)
    end
  end

  def post_file(path, file, params: {}, headers: {}, origin: nil, debug: nil, **options)
    with_options = { origin: origin }
    with_options.merge! debug: STDERR, debug_level: 2 if debug

    with_access_token(params) do |with_token_params|
      form_file = file.is_a?(HTTP::FormData::File) ? file : HTTP::FormData::File.new(file, content_type: options[:content_type])
      response = @client.plugin(:multipart).with_headers(headers).with(with_options).post(
        path,
        params: with_token_params,
        form: { media: form_file }
      )

      debug ? response : parse_response(response)
    end
  end

  protected
  def with_access_token(params = {}, tries = 2)
    @app.refresh_access_token unless @app.access_token_valid?
    yield params.merge!(access_token: @app.access_token)
  rescue AccessTokenExpiredError
    @app.refresh_access_token
    retry unless (tries -= 1).zero?
  end

  def parse_response(response)
    raise "Request get fail, response status #{response.status}" if response.status != 200
    content_type = response.content_type.mime_type

    if content_type =~ /image|audio|video/
      data = Tempfile.new('tmp')
      data.binmode
      data.write(response.body.to_s)
      data.rewind
      data
    elsif content_type =~ /html|xml/
      Hash.from_xml(response.body.to_s)
    elsif content_type =~ /json/
      response.json
    else
      JSON.parse(response.body.to_s)
    end
  end

end