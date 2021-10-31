module JiaBo
  HOST = 'https://api.poscom.cn/apisc/templetPrint'

  def common_params
    p = {
      reqTime: (Time.now.to_f * 1000).round.to_s,
      memberCode: 'x'
    }
  end

  def self.use_relative_model_naming?
    true
  end

  def self.table_name_prefix
    'jia_bo_'
  end

end
