module Com
  module Model::PgPublication
    extend ActiveSupport::Concern

    included do
      attribute :pubname, :string
    end

  end
end
