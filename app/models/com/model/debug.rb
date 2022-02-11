module Com
  module Model::Debug
    extend ActiveSupport::Concern

    included do
      after_initialize do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} after_initialize"
      end
      after_find do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} after_find"
      end
      before_validation do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} before_validation"
      end
      after_validation do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} after_validation"
      end
      before_save do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} before_save"
      end
      around_save :debug_around_save
      before_create do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} before_create"
      end
      around_create :debug_around_create
      after_create do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} after_create"
      end
      before_update do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} before_update"
      end
      around_update do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} around_update"
      end
      after_update do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} after_update"
      end
      after_save do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} after_save"
      end
      after_commit do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} after_commit"
      end
      after_rollback do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} after_rollback"
      end
      before_destroy do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} before_destroy"
      end
      around_destroy do

      end
      after_destroy do
        puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} after_destroy"
      end
    end

    def debug_around_save
      puts "#{self.class}: around_save before yield"
      yield self
      puts "#{self.class}: around_save after yield"
    end

    def debug_around_create
      puts "#{self.class}: around_create before yield"
      yield
      puts "#{self.class}: around_create after yield"
    end

    def debug_around_destroy
      puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} around_destroy"
      yield
      puts "#{self.class} new_record: #{new_record?} destroyed: #{destroyed?} around_destroy"
    end

  end
end
