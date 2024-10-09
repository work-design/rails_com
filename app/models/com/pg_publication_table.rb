module Com
  class PgPublicationTable < PgRecord
    #include Model::PgPublication
    self.table_name = 'pg_catalog.pg_publication_tables'
  end
end
