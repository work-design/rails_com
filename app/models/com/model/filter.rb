module Com
  module Model::Filter
    extend ActiveSupport::Concern

    included do
      attribute :controller_path, :string, null: false
      attribute :action_name, :string
      attribute :name, :string
      index [:controller_path, :action_name]

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :filter_columns, dependent: :delete_all
      accepts_nested_attributes_for :filter_columns
    end

    def filter_hash
      r = {}
      filter_columns.each do |col|
        r.merge! col.column => col.value
      end
      r
    end

  end
end
