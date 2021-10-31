module JiaBo
  module Model::Template
    extend ActiveSupport::Concern

    included do
      attribute :code, :string, comment: '模板编号'
      attribute :type, :string, comment: '模板类型'
      attribute :title, :string, comment: '模板名称'

      has_many :parameters
    end

  end
end
