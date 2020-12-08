module RailsCom::Debug
  extend ActiveSupport::Concern

  included do
    before_validation :debug_before_validation
    after_validation :debug_after_validation
    before_save :debug_before_save
    around_save :debug_around_save

    before_create :debug_before_create
    before_update :debug_before_update
    around_create :debug_around_create
    around_update :debug_around_update
    after_create :debug_after_create
    after_update :debug_after_update

    after_save :debug_after_save
    after_commit :debug_after_commit
  end

  def debug_before_validation
    logger.debug "  \e[35m~~~~~~~~~~ before_validation ~~~~~~~~~~\e[0m"
  end

  def debug_after_validation
    logger.debug "  \e[35m~~~~~~~~~~ after_validation ~~~~~~~~~~\e[0m"
  end

  def debug_before_save
    logger.debug "  \e[35m~~~~~~~~~~ before_save ~~~~~~~~~~\e[0m"
  end

  def debug_around_save
    logger.debug "  \e[35m~~~~~~~~~~ around_save ~~~~~~~~~~\e[0m"
  end

  def debug_before_create
    logger.debug "  \e[35m~~~~~~~~~~ before_create ~~~~~~~~~~\e[0m"
  end

  def debug_before_update
    logger.debug "  \e[35m~~~~~~~~~~ before_update ~~~~~~~~~~\e[0m"
  end

  def debug_around_create
    logger.debug "  \e[35m~~~~~~~~~~ around_create ~~~~~~~~~~\e[0m"
  end

  def debug_around_update
    logger.debug "  \e[35m~~~~~~~~~~ around_update ~~~~~~~~~~\e[0m"
  end

  def debug_after_create
    logger.debug "  \e[35m~~~~~~~~~~ after_create ~~~~~~~~~~\e[0m"
  end

  def debug_after_update
    logger.debug "  \e[35m~~~~~~~~~~ after_update ~~~~~~~~~~\e[0m"
  end

  def debug_after_save
    logger.debug "  \e[35m~~~~~~~~~~ after_save ~~~~~~~~~~\e[0m"
  end

  def debug_after_commit
    logger.debug "  \e[35m~~~~~~~~~~ after_commit ~~~~~~~~~~\e[0m"
  end

end
