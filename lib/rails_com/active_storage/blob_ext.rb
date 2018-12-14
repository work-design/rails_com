module RailsCom::BlobExt
  extend ActiveSupport::Concern
  included do
    class_attribute :private_service
  end

  def duration
    r = metadata[:duration] || 0
    rh = TimeHelper.exact_distance_time(r.to_f)
    "#{rh[:minute]}:#{rh[:second].to_s.rjust(2, '0')}"
  end

  def service
    rts = self.attachments.pluck(:record_type, :name).uniq.to_combined_h
    ps = ActiveStorage::BlobDefault.where(private: true).pluck(:record_class, :name)
    private = ps.slice(rts.keys)

    if private
      private_service
    else
      super
    end
  end

end

ActiveSupport.on_load(:active_storage_blob) do
  include RailsCom::BlobExt
  config_choice = Rails.configuration.active_storage.private_service
  configs = Rails.configuration.active_storage.service_configurations
  ActiveStorage::Blob.private_service = ActiveStorage::Service.configure config_choice, configs
end
