require 'rails_com/version'
require 'rails_com/engine'
require 'rails_com/config'

# Meta for Rails
require 'rails_com/meta/routes'
require 'rails_com/meta/models'
require 'rails_com/meta/controllers'

# Rails Helper
require 'rails_com/helpers/model_helper'
require 'rails_com/helpers/controller_helper'

# Ruby core extension
require 'rails_com/core_ext/hash'
require 'rails_com/core_ext/nil'
require 'rails_com/core_ext/array'
require 'rails_com/core_ext/date'
require 'rails_com/core_ext/nemeric'

# Rails extension
require 'rails_com/rails_ext/template_renderer'
require 'rails_com/rails_ext/scaffold_generator'
require 'rails_com/rails_ext/named_base'
require 'rails_com/rails_ext/activestorage_attached'
require 'rails_com/rails_ext/persistence_sneakily'
require 'rails_com/rails_ext/translation_helper'
require 'rails_com/rails_ext/video_response'
require 'rails_com/rails_ext/attachment_transfer'
require 'rails_com/sprockets/non_digest_assets'

# Utils
require 'rails_com/utils/time_helper'
require 'rails_com/utils/num_helper'
require 'rails_com/utils/uid_helper'
require 'rails_com/utils/jobber'