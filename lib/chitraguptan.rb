require 'chitraguptan/config'
require 'chitraguptan/main'
require 'chitraguptan/model/variable'
require 'redis'

module Chitraguptan
  def self.load
    @load ||= begin
      load_object
      true
    end
  end

  def self.redis
    load_object.config.redis
  end

  def self.get(key, default: nil)
    load_object.get(key, default)
  end

  def self.delete(key)
    load_object.get(key)
  end

  def self.update(key, value: )
    load_object.update(key, value)
  end

  def self.show_all
    load_object.all
  end

  def self.delete_all
    load_object.delete_all
  end

  def self.load_object
    @object ||= Chitraguptan::Main.new(Chitraguptan::Config.new)
  end
end
