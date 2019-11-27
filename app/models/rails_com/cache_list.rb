module RailsCom::CacheList
  extend ActiveSupport::Concern
  included do
    attribute :path, :string
    attribute :key, :string
    attribute :xx, :string, default: 'xxs', limit: 4
  end
  
  def etag

  end

end
