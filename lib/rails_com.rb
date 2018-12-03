require 'rails_com/version'
require 'rails_com/engine'
require 'rails_com/config'

require 'rails_com/core'
require 'rails_com/action_controller'
require 'rails_com/action_view'
require 'rails_com/active_record'
require 'rails_com/active_storage'

# Meta for Rails
require 'rails_com/meta/routes'
require 'rails_com/meta/models'
require 'rails_com/meta/controllers'

# Rails extension
require 'rails_com/generators/named_base'
require 'rails_com/generators/scaffold_generator'

# controllers
require 'rails_com/sprockets/non_digest_assets'

# Utils
require 'rails_com/utils/time_helper'
require 'rails_com/utils/num_helper'
require 'rails_com/utils/uid_helper'
require 'rails_com/utils/jobber'
require 'rails_com/utils/babel'
