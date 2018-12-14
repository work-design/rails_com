module RailsCom::BlobExt

  def self.prepended(klass)
    klass.class_attribute :private_service
  end

  def duration
    r = metadata[:duration] || 0
    rh = TimeHelper.exact_distance_time(r.to_f)
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
    rts = self.attachments.pluck(:record_type, :name).uniq.to_combined_h
    ps = ActiveStorage::BlobDefault.where(private: true).pluck(:record_class, :name).to_combined_h
    @private = ps.slice(*rts.keys).map { |p, v| (Array(rts[p]) - Array(v)).blank? }.uniq == [true]
  end

end

ActiveSupport.on_load(:active_storage_blob) do
  prepend RailsCom::BlobExt
end
