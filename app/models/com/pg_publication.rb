module Com
  class PgPublication < ApplicationRecord
    include Model::PgPublication

    self.table_name = 'pg_publication'
    self.primary_key = 'oid'
  end
end
