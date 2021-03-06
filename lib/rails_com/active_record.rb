# frozen_string_literal: true

module RailsCom::ActiveRecord; end
require 'rails_com/active_record/i18n'
require 'rails_com/active_record/enum'
require 'rails_com/active_record/translation'
require 'rails_com/active_record/extend'
require 'rails_com/active_record/include'

# enum has an attribute define, which get default value form this
ActiveRecord::Type.instance_variable_set :@default_value, ActiveModel::Type::String.new
