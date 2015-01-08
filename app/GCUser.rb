require 'json'
require 'redis'
require 'GCUtil'

class GCUser

  def self::exist? username
    return true if redis.get('user_'+username)
    false
  end

  def self::uid_exist? uid
    return true if redis.get('uid_'+uid)
    false
  end

  def self::create username, hash
    if !GCUser::exist? username
      data = {}
      GCUtil::user_keys.each do |key|
        key_sym = key.to_sym
        data[key_sym] = hash[key_sym]
      end
      while GCUser::uid_exist? data[:uid] = GCUtil::generate_code 4 end
      redis.set('user_'+username, data.to_json) # remember to add mutex under multi-threading
      redis.set('uid_'+data[:uid], 'user_'+username)
    end
  end

  def initialize username
    @username = username
    @info = JSON.parse(redis.get('user_'+username), :symbolize_names => true) if GCUser::exist? username
  end

  def getuid
    @info[:uid] if @info
  end

  def password_correct? sha
    @info[:password] == sha if @info
  end

  def set_password sha
    if @info
      @info[:password] = sha
      redis.set('user_'+@username, @info.to_json)
    end
  end

  def getcontacts
    @info[:contacts] if @info
  end

  def redis
    # should new from config file
    @redis = Redis.new if !@redis
    @redis
  end

  private :redis

end