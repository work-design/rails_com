module ObjectUtil
  extend self

  def memory_usage(klass)
    Rails.logger.debug "\e[35m  #{klass.name} Memory Usage: #{ObjectSpace.memsize_of_all(klass).to_fs(:human_size)}  \e[0m"
    present_ids = ObjectSpace.each_object(klass).map { |i| i.__id__ }
    Rails.logger.debug "\e[35m  Present #{klass.name} Object: #{present_ids}, Count: #{present_ids.size}  \e[0m"
  end

  def present_objects(klass, ids)
    present_ids = ObjectSpace.each_object(klass).map { |i| i.__id__ }
    Rails.logger.debug "\e[35m  Present Object: #{present_ids & ids}  \e[0m"
  end

end