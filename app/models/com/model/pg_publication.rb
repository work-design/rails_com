module Com
  module Model::PgPublication
    extend ActiveSupport::Concern

    included do
      attribute :pubname, :string

      has_many :pg_publication_tables, primary_key: :pubname, foreign_key: :pubname
    end

  end
end
