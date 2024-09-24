module Com
  class AppTest < ApplicationJob

    def perform(app)
      HTTPX.get app
    end

  end
end
