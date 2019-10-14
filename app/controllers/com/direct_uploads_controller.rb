class Com::DirectUploadsController < ActiveStorage::DirectUploadsController
  skip_before_action :verify_authenticity_token

  def create
    super
  end

end
