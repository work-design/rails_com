module ActionController
  class StandardError < ::StandardError
    attr_accessor :code
  end

  class UnauthorizedError < StandardError
  end

  class ForbiddenError < StandardError
  end
end
