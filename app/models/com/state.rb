module Com
  class State < ApplicationRecord
    include Model::State
    include Com::Ext::Taxon
  end
end
