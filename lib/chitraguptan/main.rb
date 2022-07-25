class Chitraguptan::Main
  def initialize(config)
    @config = config
    setup
  end

  attr_reader :config

  def get(key, default)
    value = get_key(key)
    return parse_and_fetch(value) if value

    set_key(key, default)
    persist_key(key)
    parse_and_fetch(get_key(key))
  end

  def del(key)
    return true if del_key(key) == 1

    false
  end

  def update(key, value)
    set_key(key, value) if value
    persist_key(key)
    true
  end

  def all_keys
    @config.redis.keys("#{@config.prefix}:*")
  end

  def all
    all_keys.map do |key|
      { key: key, value: parse_and_fetch(get_raw_key(key))}
    end
  end

  def delete_all
    @config.redis.keys("#{@config.prefix}:*").map do |key|
      del_raw_key(key)
    end
  end

  private

  def parse_value(value)
    JSON.parse(value)
  end

  def parse_and_fetch(value)
    parse_value(value)['value']
  end

  def setup
    confirm_key_exist_if_not_load # this should be configurable as it would slow down the rails app boot time
  end

  def confirm_key_exist_if_not_load
    Chitraguptan::Variable.find_each do |variable|
      set_key(variable.key, variable.key_value) unless get_key(variable.key)
    end
  end

  def get_key(key)
    get_raw_key("#{@config.prefix}:#{key}")
  end

  def get_raw_key(raw_key)
    @config.redis.get(raw_key)
  end

  def set_key(key, default)
    raise Chitraguptan::Errors::NoDefault unless default

    @config.redis.set("#{@config.prefix}:#{key}", { value: default }.to_json)
  end

  def del_key(key)
    del_raw_key("#{@config.prefix}:#{key}")
  end

  def del_raw_key(key)
    @config.redis.del(key)
  end

  def persist_key(key)
    Chitraguptan::Variable.where(key: key).first_or_initialize.update(value: { value: parse_and_fetch(get_key(key))}.to_json)
  end
end
