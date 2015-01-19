require 'json'
require 'redis'
require 'gitcontacts/GCUtil'
require "gitdb"

class GCContacts

  def self::exist? gid
    return true if redis.get('contacts_'+gid)
    false
  end

  def self::create gid, hash
    gid = nil
    while GCContacts::exist? gid = GCUtil::generate_code(4)
    end
    data = {}
    GCUtil::contacts_keys.each do |key|
      data[key] = hash[key]
    end
    redis.set('contacts_'+gid, data.to_json)
  end

  def initialize gid
    @gid = gid
    @info = JSON.parse(redis.get('contacts_'+gid), :symbolize_names => true) if GCContacts::exist? gid
  end

  def getrepo
    @info[:repo] if @info
  end

  def getusers
    @info[:users] if @info
  end

  def getadmins
    @info[:admins] if @info
  end

  def add_user user
    if @info
      users = (@info[:users] << user).uniq
      set_users users
    end
  end

  def remove_user user
    if @info
      users = @info[:users] - [user]
      set_users users
    end
  end

  def set_users users
    @info[:users] = users if @info
    redis.set('contacts_'+@gid, @info.to_json)
  end

  def add_admin admin
    if @info
      admins = (@info[:admins] << admin).uniq
      set_admins admins
    end
  end

  def remove_admin admin
    if @info
      admins = @info[:admins] - [admin]
      set_admins admins
    end
  end

  def set_admins admins
    @info[:admins] = admins if @info
    redis.set('contacts_'+@gid, @info.to_json)
  end

  def redis
    # should new from config file
    @redis = Redis.new if !@redis
    @redis
  end

  private :redis

end