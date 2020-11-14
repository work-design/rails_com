# frozen_string_literal: true

require 'rails_com/version'
require 'rails_com/engine'
require 'rails_com/config'

require 'rails_com/core'
require 'rails_com/action_controller'
require 'rails_com/action_view'
require 'rails_com/action_text'
require 'rails_com/action_mailbox'
require 'rails_com/active_record'
require 'rails_com/active_model'
require 'rails_com/active_storage'

# Meta for Rails
require 'rails_com/meta/routes'
require 'rails_com/meta/models'
require 'rails_com/meta/env'

# Rails extension
require 'rails_com/generators'
require 'generators/scaffold_generator'
require 'generators/jbuilder_generator' if defined?(Jbuilder)

# controllers
require 'rails_com/webpacker/yaml_helper'

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
