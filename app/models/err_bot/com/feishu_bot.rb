module Com
  class FeishuBot < ErrBot
    include Model::ErrBot::FeishuBot
    include Model::Inner::FeishuBot
  end
end
