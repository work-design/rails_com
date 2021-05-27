module RailsCom::ActionText::RichText
  extend ActiveSupport::Concern

  included do
    attribute :name, :string, null: false
    attribute :body, :text, size: :long
    index [ :record_type, :record_id, :name ], name: 'index_action_text_rich_texts_uniqueness', unique: true
  end

end

ActiveSupport.on_load :action_text_rich_text do
  include RailsCom::ActionText::RichText
end
