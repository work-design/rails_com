module Com
  class PgPublicationTable < ApplicationRecord
    #include Model::PgPublication

    self.table_name = 'pg_publication_tables'
  end
end
