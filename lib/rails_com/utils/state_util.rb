module StateUtil
  extend self

  def urlsafe_encode64(host:, controller:, action: 'index', method: 'get', params: {})
    state = [host, controller, action, method, params.to_query].compact_blank
    state.map! { |i| Base64.urlsafe_encode64(i, padding: false) }
    state.join('~')
  end

  def urlsafe_decode64(str)
    state_hash = str.split('~')
    state_hash.map! { |i| Base64.urlsafe_decode64(i) }

    {
      host: state_hash[0],
      controller: state_hash[1],
      action: state_hash[2],
      **state_hash[4].to_s.split('&').map(&->(i){ i.split('=') }).to_h
    }
  end

end
