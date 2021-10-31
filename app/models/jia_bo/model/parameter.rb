module JiaBo
  module Model::Parameter
    extend ActiveSupport::Concern

    included do
      attribute :name, :string, comment: '参数名称'
      attribute :code, :string, comment: '参数 code'
      attribute :comment, :string, comment: '评论'

      belongs_to :template
    end

  end
end
