module Com
  class Counter < ApplicationRecord
    include Model::Counter
    include Ext::Cte
  end
end
