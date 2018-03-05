require 'rails_com/version'

require 'rails_com/routes'
require 'rails_com/models'
require 'rails_com/controllers'
require 'rails_com/model_helper'
require 'rails_com/controller_helper'
require 'rails_com/sprockets/non_digest_assets'

require 'rails_com/helpers/uid_helper'
require 'rails_com/helpers/jobber'

require 'rails_com/core_ext/hash'
require 'rails_com/core_ext/nil'

require 'rails_com/rails_ext/template_renderer'
require 'rails_com/rails_ext/scaffold_generator'

require 'utils/time_helper'

require 'rails_com/engine'

module RailsCom
  mattr_accessor :not_found_logger

  self.not_found_logger = ActiveSupport::Logger.new('log/not_found.log')
end