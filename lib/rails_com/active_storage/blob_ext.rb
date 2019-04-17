module RailsCom::BlobExt

  def self.prepended(klass)
    klass.class_attribute :private_service
  end

  def duration
    (metadata[:duration] || 0).to_f
  end

  def duration_str
    rh = TimeHelper.exact_distance_time(duration)
    "#{rh[:minute]}:#{rh[:second].to_s.rjust(2, '0')}"
  end

  def service
    if private && private_service
      private_service
    else
      super
    end
  end

  def private
    return @private if defined?(@private)
    rts = self.attachments.pluck(:record_type, :name).uniq.to_array_h.to_combine_h
    ps = Rails.cache.fetch('blob_default/private') do
      ActiveStorage::BlobDefault.where(private: true).pluck(:record_class, :name).to_array_h.to_combine_h
    end
    @private = ps.slice(*rts.keys).map { |p, v| (Array(rts[p]) - Array(v)).blank? }.uniq == [true]
  end

  def identify_later
    ActiveStorage::IdentifyJob.perform_later(self)
  end

end

ActiveSupport.on_load(:active_storage_blob) do
  prepend RailsCom::BlobExt
end
