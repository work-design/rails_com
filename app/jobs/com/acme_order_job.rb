module Com
  class AcmeOrderJob < ApplicationJob

    def perform(acme_order)
      acme_order.renew_order
    end

  end
end
