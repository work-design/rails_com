require_relative 'rails_com/version'
require_relative 'rails_com/engine'
require_relative 'rails_com/config'

require_relative 'rails_com/core'
require_relative 'rails_com/action_controller'
require_relative 'rails_com/action_view'
require_relative 'rails_com/active_record'

require_relative 'rails_com/active_storage/blob_ext'

# Meta for Rails
require_relative 'rails_com/meta/routes'
require_relative 'rails_com/meta/models'
require_relative 'rails_com/meta/controllers'
require_relative 'rails_com/meta/env'

# Rails extension
require_relative 'rails_com/generators/named_base'
require_relative 'rails_com/generators/scaffold_generator'

# controllers
require_relative 'rails_com/sprockets/non_digest_assets'

# Utils
require_relative 'rails_com/utils/time_helper'
require_relative 'rails_com/utils/num_helper'
require_relative 'rails_com/utils/uid_helper'
require_relative 'rails_com/utils/jobber'
require_relative 'rails_com/utils/babel'

# outside
require 'default_where'
require 'default_form'
