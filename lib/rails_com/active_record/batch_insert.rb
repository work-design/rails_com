module RailsCom::BatchInsert

  # user by  in_batches:
  #  * of
  # Notification.bulk_insert_from_model User, select: { receiver_id: 'id' }, value: { title: 'title', body: 'body' }, default: { }, of: 2
  def bulk_insert_from_model(model, select: {}, value: {}, default: { created_at: 'localtimestamp', updated_at: 'localtimestamp' }, **options)
    raise 'select must exists!' if select.blank?
    v = value.values.map { |i| "'#{i}'" }
    keys = [select.keys, value.keys, default.keys].flatten.join(', ')
    text = [v, default.values].flatten.join(', ')

    enums = model.select(select.values).in_batches(options.slice(:of, :start, :finish, :load, :error_on_ignore)).each
    enums.each do |i|
      select_str, where_str = i.to_sql.delete('\"').split(' FROM ')
      if text.present?
        select_str += ", #{text}"
      end
      connection.execute("INSERT INTO #{table_name} (#{keys}) #{select_str} FROM #{where_str}")
    end
  end

end

ActiveSupport.on_load :active_record do
  extend RailsCom::BatchInsert
end
