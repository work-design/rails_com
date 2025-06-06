module RailsCom::ActiveRecord
  module ExtendJson

    def increment_json_counter(*cols, column: 'counters', num: 1)
      cols.inject(column) do |sql, col|
        "jsonb_set(#{sql}, '{#{col}}', (COALESCE(counters->>'#{col}', '0')::int + #{num})::text::jsonb)"
      end
    end

    def decrement_json_counter(col, num = 1)
      s = "jsonb_set(counters, '{#{col}}', (COALESCE(counters->>'#{col}', '0')::int - #{num})::text::jsonb)"

      sql = "counters = #{s}"
      update_all sql
    end

    def update_json_counter
      sql = "counters = #{s}"
      update_all sql
    end

    def json_filter(column, params)
      query = self

      params.each do |k, v|
        if v.is_a?(Array)
          or_string = []
          v.size.times { or_string << "#{column}->>'#{k}' = ?" }
          query = query.where([or_string.join(' OR '), *v])
        else
          query = query.where("#{column}->>'#{k}' = ?", v)
        end
      end

      query
    end

  end
end

ActiveSupport.on_load :active_record do
  extend RailsCom::ActiveRecord::ExtendJson
end
