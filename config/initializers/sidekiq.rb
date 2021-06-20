if Rails.env.development?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
else
  Sidekiq.configure_server do |config|
    config.redis = { 
      url: ENV.fetch("SIDEKIQ_REDIS_URL") { "redis://localhost:6379/1" },
      namespace: "tickets2"
    }
    schedule_file = "config/schedule.yml"
    if File.exist?(schedule_file) && Sidekiq.server?
      Sidekiq::Cron::Job.destroy_all!
      Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
    end
  end
  Sidekiq.configure_client do |config|
      config.redis = { 
        url: ENV.fetch("SIDEKIQ_REDIS_URL") { "redis://localhost:6379/1" },
        namespace: "tickets2"
      }
  end
end