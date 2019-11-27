module RailsCom::CacheList
  extend ActiveSupport::Concern
  included do
    attribute :path, :string
    attribute :key, :string
    attribute :xx, :string
  end
  
  def etag

  end

end
