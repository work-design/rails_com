module StateUtil
  extend self

  def encode(request)
    state = [
      request.host,
      "/#{request.params['controller']}",
      request.params['action'],
      request.path_parameters.except(:business, :namespace, :controller, :action).merge!(request.query_parameters).to_query
    ].compact_blank
    state.map! { |i| Base64.urlsafe_encode64(i, padding: false) }
    state.join('~')
  end

  def decode(str)
    state_hash = str.split('~')
    state_hash.map! { |i| Base64.urlsafe_decode64(i) }

    {
      host: state_hash[0],
      controller: state_hash[1],
      action: state_hash[2],
      **Rack::Utils.parse_nested_query(state_hash[3].to_s).symbolize_keys!
    }
  end

end
