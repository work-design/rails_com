# frozen_string_literal: true

module RailsCom::BlobPrepend

  def self.prepended(klass)
    klass.attribute :key, :string, null: false, index: { unique: true }
    klass.attribute :filename, :string, null: false
    klass.attribute :content_type, :string
    klass.attribute :metadata, :json
    klass.attribute :byte_size, :integer, null: false
    klass.attribute :checksum, :string
    klass.attribute :service_name, :string, null: false
    klass.attribute :created_at, :datetime, null: false
  end

  def data_url
    return @data_url if defined? @data_url
    @data_url = "data:#{content_type};base64,#{Base64.encode64(download)}"
  end

  def duration
    (metadata[:duration] || 0).to_f
  end

  def duration_str
    rh = TimeHelper.exact_distance_time(duration)
    "#{rh[:minute]}:#{rh[:second].to_s.rjust(2, '0')}"
  end

  def identify_later
    ActiveStorage::IdentifyJob.perform_later(self)
  end

end

ActiveSupport.on_load(:active_storage_blob) do
  prepend RailsCom::BlobPrepend
end
