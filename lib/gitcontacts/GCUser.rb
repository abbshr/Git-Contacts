require 'json'
require 'redis'
require 'gitcontacts/GCUtil'

class GCUser

  def self::exist? email
    return true if redis.get('user_'+email)
    false
  end

  def self::uid_exist? uid
    return true if redis.get('uid_'+uid)
    false
  end

  def self::uid_to_email uid
    redis.get('uid_'+uid)
  end

  def self::email_to_uid email
    if GCUser::exist? email
      user = JSON.parse(redis.get('user_'+email), :symbolize_names => true)
      user[:uid]
    end
  end

  def self::create email, hash
    if !GCUser::exist? email
      data = {}
      GCUtil::user_keys.each do |key|
        key_sym = key.to_sym
        data[key_sym] = hash[key_sym]
      end
      while GCUser::uid_exist? data[:uid] = GCUtil::generate_code 4 end
      redis.set('user_'+email, data.to_json) # remember to add mutex under multi-threading
      redis.set('uid_'+data[:uid], email)
    end
  end

  def initialize email
    @email = email
    @info = JSON.parse(redis.get('user_'+email), :symbolize_names => true) if GCUser::exist? email
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
      redis.set('user_'+@email, @info.to_json)
    end
  end

  def getcontacts
    @info[:contacts] if @info
  end

  def add_contacts gid
    if @info
      contacts = (@info[:contacts] << gid).uniq
      set_contacts contacts
    end
  end

  def set_contacts contacts
    @info[:contacts] = contacts
    redis.set('user_'+@email, @info.to_json)
  end

  def redis
    # should new from config file
    @redis = Redis.new if !@redis
    @redis
  end

  private :redis

end