# frozen_string_literal: true
module Com
  module Model::Info
    extend ActiveSupport::Concern

    included do
      attribute :code, :string, default: 'ss', limit: '2', comment: 'dddd'
      attribute :value, :string
      attribute :version, :string

      enum platform: {
        ios: 'ios',
        android: 'android'
      }
    end

    class_methods do

      def verbose(q_params = nil)
        r = Info.default_where(q_params).as_json(only: [:code, :value])
        result = {}
        r.map { |i| result[i['code']] = i['value'] }
        result
      end

    end

  end
end
