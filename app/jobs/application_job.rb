class ApplicationJob < ActiveJob::Base

  retry_on StandardError do |job, error|
    Com::ErrBot.first_time.each do |bot|
      bot.send_err_message(
        {
          job: job.class.name,
          job_id: job.job_id,
          queue_name: job.queue_name,
          error: error.message,
          arg: job.arguments.join('')
        }
      )
    end
  end

end
