module Com
  module Model::Debug
    extend ActiveSupport::Concern

    included do
      after_initialize do
        puts "#{self.class} after_initialize new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      after_find do
        puts "#{self.class} after_find new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      before_validation do
        puts "#{self.class} before_validation new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      after_validation do
        puts "#{self.class} after_validation new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      before_save do
        puts "#{self.class} before_save new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      around_save :debug_around_save
      before_create do
        puts "#{self.class} before_create new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      around_create :debug_around_create
      after_create do
        puts "#{self.class} after_create new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      before_update do
        puts "#{self.class} before_update new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      around_update do
        puts "#{self.class} around_update new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      after_update do
        puts "#{self.class} after_update new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      after_save do
        puts "#{self.class} after_save new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      after_commit do
        puts "#{self.class} after_commit new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      after_rollback do
        puts "#{self.class} after_rollback new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      before_destroy do
        puts "#{self.class} before_destroy new_record: #{new_record?} destroyed: #{destroyed?}"
      end
      around_destroy :debug_around_destroy
      after_destroy do
        puts "#{self.class} after_destroy new_record: #{new_record?} destroyed: #{destroyed?}"
      end
    end

    def debug_around_save
      puts "#{self.class} around_save before yield new_record: #{new_record?} destroyed: #{destroyed?}"
      yield
      puts "#{self.class} around_save after yield new_record: #{new_record?} destroyed: #{destroyed?}"
    end

    def debug_around_create
      puts "#{self.class} around_create before yield new_record: #{new_record?} destroyed: #{destroyed?}"
      yield
      puts "#{self.class} around_create after yield new_record: #{new_record?} destroyed: #{destroyed?}"
    end

    def debug_around_destroy
      puts "#{self.class} around_destroy before yield new_record: #{new_record?} destroyed: #{destroyed?}"
      yield
      puts "#{self.class} around_destroy after yield new_record: #{new_record?} destroyed: #{destroyed?}"
    end

  end
end
