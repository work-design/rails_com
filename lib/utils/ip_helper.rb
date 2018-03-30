# frozen_string_literal: true

module IpHelper
  extend self

  def read(name)
    IpAddress.delete_all
    IO.foreach(name) do |x|
      if x.match? /apnic\|CN\|ipv4/
        r = x.split('|').values_at(3, 4)
        min = IPAddr.new(r[0]).to_i
        max = min + r[1].to_i - 1
        max_ip = IPAddr.new(max, Socket::AF_INET).to_s
      end
    end
  end

  def save
    IpAddress.create(
      int_start: min,
      int_finish: max,
      ip_start: r[0],
      ip_finish: max_ip,
      ip_type: 'ipv4',
      registry: 'CN'
    )
  end

end