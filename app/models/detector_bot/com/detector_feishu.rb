module Com
  class DetectorFeishu < DetectorBot
    include Model::DetectorBot::DetectorFeishu
    include Model::Inner::FeishuBot
  end
end
