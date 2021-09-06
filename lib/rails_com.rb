# frozen_string_literal: true

require 'rails_com/config'
require 'rails_com/engine'

require 'rails_com/action_controller'
require 'rails_com/action_view'
require 'rails_com/action_text'
require 'rails_com/action_mailbox'
require 'rails_com/active_record'
require 'rails_com/active_storage'
require 'rails_com/quiet_logs'

# Rails extension
require 'rails_com/generators'
require 'generators/scaffold_generator'
require 'generators/jbuilder_generator' if defined?(Jbuilder)

# default_form, 需要位于 rails_com 的加载之后
require 'default_form/config'
require 'default_form/active_record/extend'
require 'default_form/override/action_view/helpers/tags/collection_check_boxes'
require 'default_form/override/action_view/helpers/tags/collection_radio_buttons'
require 'default_form/controller_helper'
require 'default_form/view_helper'

# Utils
require 'rails_com/utils/time_helper'
require 'rails_com/utils/num_helper'
require 'rails_com/utils/qrcode_helper'
require 'rails_com/utils/uid_helper'
require 'rails_com/utils/hex_helper'
require 'rails_com/utils/jobber'

# active storage
require 'active_storage/service/disc_service'

# outside
require 'default_where'
require 'kaminari'
require 'acts_as_list'
require 'turbo-rails'
