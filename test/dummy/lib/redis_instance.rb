module RedisInstance
  class << self
    # Starts RedisInstance
    def start
      return false unless redis_installed?

      check_snapshot_folder

      `redis-server #{config_file_path} --port #{port} --logfile #{log_file_path} --pidfile #{pid_file_path} --dir #{snapshot_folder_path}`

      sleep 1

      is_running?
    end

    # Stops RedisInstance
    def stop
      `kill -s SIGTERM #{pid}`
      sleep 1

      if is_running?
        puts "Redis is still running. Exiting now w/o saving a snapshot."
        `kill -s QUIT #{pid}`
        sleep 1
      end

      !is_running?
    end

    # Stops and then restarts RedisInstance
    def restart
      stop if is_running?
      start

      is_running?
    end

    # Returns true if instance is running
    def is_running?
      result = ""
      result = `ps -p #{pid} -o cmd=`.gsub("\n", "") unless pid.empty?

      running = result.split.first == "redis-server" ? true : false

      running
    end

    private
      # Returns true if redis is installed, otherwise false
      def redis_installed?
        result = `which redis-server`.gsub("\n", "")

        puts "redis-server-binary not found" if result.empty?

        result.empty? ? false : true
      end

      # Looks for a folder to dump .rdb-snapshots into
      # If none exists, create it
      def check_snapshot_folder
        Dir.mkdir(snapshot_folder_path) unless Dir.exists?(snapshot_folder_path)
      end

      # Path to snapshot-folder
      def snapshot_folder_path
        rails_root + "/tmp/rdb_snapshots/"
      end

      # Returns the port redis listens to
      def port
        7779
      end

      # Returns PID from file
      def pid
        `cat #{pid_file_path}`.gsub("\n", "")
      end

      # Returns PID-file-path
      def pid_file_path
        rails_root + "/tmp/pids/redis.pid"
      end

      # Returns path to config file
      def config_file_path
        rails_root + "/config/redis.conf"
      end

      # Returns path to log file
      def log_file_path
        rails_root + "/log/redis.log"
      end

      # Returns path to rails-root
      def rails_root
        `pwd`.gsub("\n", "")
      end
  end
end
