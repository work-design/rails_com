require 'rails_com/sprockets/non_digest_assets'
require 'rails_com/sprockets/qiniu_exporter'


module Sprockets

  def self.sync
    config[:sync]
  end

  def self.sync=(sync)
    self.config = hash_reassoc(config, :sync) { sync.dup }
  end

end
