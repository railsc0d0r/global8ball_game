require_relative '../redis_instance'

namespace :redis do
  desc "Starts redis-instance"
  task start: :environment do
    RedisInstance.start
  end

  desc "Stops redis-instance"
  task stop: :environment do
    RedisInstance.stop
  end

  desc "Restarts redis-instance"
  task restart: :environment do
    RedisInstance.restart
  end

  desc "Status of redis-instance"
  task status: :environment do
    puts RedisInstance.is_running? ? "Redis is running." : "Redis is not running."
  end

  desc "Flushes DB for RAILS_ENV"
  task flush_db: :environment do
    RedisInstance.flush_db
  end
end
