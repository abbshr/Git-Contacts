require "gitdb"

class GCRequest

  def self::exist? qid
    return true if redis.get('request_'+qid)
    false
  end

  def self::create hash
    qid = nil
    while GCRequest::exist? qid = GCUtil::generate_code(4) 
    end 
    data = {}
    GCUtil::request_keys.each do |key|
      data[key] = hash[key]
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
    #
    # 依据请求文本, 执行gitdb操作
    # e.g.
    # 请求格式:
    #
    # req = {  
    #   gid_1: [{
    #     => type: setmeta/setdata/delete
    #     => card: id,
    #     => data: {}
    #   },{
    #     => type: setmeta/setdata/delete
    #     => card: id,
    #     => data: {}
    #   }, ...],
    #   gid_2: [{
    #     => type: setmeta/setdata/delete
    #     => card: id,
    #     => data: {}
    #   },{
    #     => type: setmeta/setdata/delete
    #     => card: id,
    #     => data: {}
    #   }, ...],
    #   ...
    # }
    # 
    # req.each do |gid|
      # contacts = Contacts.new(uid).access(gid)
      # req[gid].each do |reqhash|
        # card = Card.new(contacts.repo).access(reqhash.card)
        # if reqhash.type == :setmeta
        #   card.setmeta data
        # elif reqhash.type == :setdata
        #   card.setdata data
        # else
        #   card.delete
        # end
      # end
      # contacts.make_a_commit :author => { :name => , :email => , :time => }, 
      #                        :committer => { :name => , :email => , :time => Time.now}
    # end
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