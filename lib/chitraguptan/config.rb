module Chitraguptan
  class Config
    def initialize(redis = Redis.new, prefix='chitraguptan', persist=true)
      @redis  = redis
      @prefix = prefix
      @persis = persist
    end

    attr_reader :redis, :prefix, :persist
  end
end
