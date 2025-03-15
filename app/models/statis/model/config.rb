module Statis
  module Model::Config
    extend ActiveSupport::Concern

    included do
      attribute :statistical_type, :string
      attribute :year, :integer
      attribute :begin_on, :date
      attribute :end_on, :date
      attribute :note, :string
      attribute :keys, :json, default: []
      attribute :scopes, :json, default: []
      attribute :today, :date
      attribute :today_begin_id, :big_integer

      has_many :counters, primary_key: :statistical_type, foreign_key: :countable_type
    end

    def compute_today_begin!
      id = statistical_type.constatize.where(created_at: ...Date.today.beginning_of_day.to_fs(:human)).order(id: :desc).first.id
      self.today_begin_id = id
      self.today = Date.today
      self.save
    end

    def keys_gen

    end

  end
end
