class GCRequest

  def self::exist? qid
    return true if redis.get('request_'+qid)
    false
  end

  def self::create hash
    qid = nil
    while GCRequest::exist? qid = GCUtil::generate_code 4 end 
    data = {}
    GCUtil::request_keys.each do |key|
      key_sym = key.to_sym
      data[key_sym] = hash[key_sym]
    end
    redis.set('request_'+gid, data.to_json)
    qid
  end

  def self::delete qid
    redis.del('request_'+qid) > 0
  end

  def initialize qid
    @qid = qid
    @info = JSON.parse(redis.get('request_'+qid), :symbolize_names => true) if GCRequest::exist? qid
  end

  def getuid
    @info[:uid] if @info
  end

  def getaction
    @info[:action] if @info
  end

  def getcontent
    @info[:content] if @info
  end


  def can_auto_merge? uid
    uid == getuid
  end

  def allow
    # allow merge here
  end

  def deny
    # deny merge here
    GCRequest::delete(@qid)
  end

  def redis
    # should new from config file
    @redis = Redis.new if !@redis
    @redis
  end

  private :redis

end