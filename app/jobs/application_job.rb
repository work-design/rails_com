class ApplicationJob < ActiveJob::Base

  retry_on do |job, error|
    Com::ErrBot.first_time.each do |bot|
      bot.send_err_message(
        {
          job: job.class.name,
          error: error
        }
      )
    end
  end

end
