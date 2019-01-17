module RailsCom::BatchInsert

  # user by  in_batches:
  #  * of
  # Notification.bulk_insert_from_model User, select: { receiver_id: 'id' }, value: { title: 'title', body: 'body' }, default: { }, of: 2
  def bulk_insert_from_model(model, select:, value: {}, default: { created_at: 'localtimestamp', updated_at: 'localtimestamp' } **options)
    v = value.values.map { |i| "'#{i}'" }

    enums = model.select(Array(select), v, default.values).in_batches(options.slice(:of)).each
    enums.each do |i|
      p "INSERT INTO #{table_name} (#{select.keys.join(', ')}, #{value.keys.join(', ')}, #{default.keys.join(', ')}) #{i.to_sql}"
    end
  end

end

ActiveSupport.on_load :active_record do
  extend RailsCom::BatchInsert
end
