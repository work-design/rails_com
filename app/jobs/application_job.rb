class ApplicationJob < ActiveJob::Base

  retry_on StandardError, attempts: 0 do |job, error|
    Com::ErrBot.first_time.each do |bot|
      bot.send_err_message(
        {
          job: job.class.name,
          job_id: job.job_id,
          queue_name: job.queue_name,
          error: error.message
          #arg: job.arguments.fetch('arguments', [])[0]
        }
      )
    end
  end

end
