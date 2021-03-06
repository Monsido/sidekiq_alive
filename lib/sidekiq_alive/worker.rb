module SidekiqAlive
  class Worker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform
      write_living_probe
      self.class.perform_in(config.time_to_live / 2)
    end

    def write_living_probe
      # Write liveness probe
      SidekiqAlive.store_alive_key
      # after callbacks
      config.callback.call()
    end

    def config
      SidekiqAlive.config
    end
  end
end
