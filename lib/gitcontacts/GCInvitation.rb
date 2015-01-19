require 'json'
require 'redis'
require 'gitcontacts/GCUtil'

class GCInvitation

  def self::exist? code
    return true if redis.get('invite_'+code)
    false
  end

  def self::create hash
    code = nil
    while GCInvitation::exist? code = GCUtil::generate_code(4) 
    end
    data = {}
    GCUtil::invitation_keys.each do |key|
      data[key] = hash[key]
    end
    redis.set('invite_'+code, data.to_json)
  end

  def self::delete code
    redis.del('invite_'+code) > 0
  end

  def initialize code
    @code = code
    @info = JSON.parse(redis.get('invite_'+code), :symbolize_names => true) if GCInvitation::exist? code
  end

  def getuid
    @info[:uid] if @info
  end

  def getcontacts
    @info[:contacts] if @info
  end

  def accept? uid
    uid == getuid
  end

  def redis
    # should new from config file
    @redis = Redis.new if !@redis
    @redis
  end

  private :redis

end