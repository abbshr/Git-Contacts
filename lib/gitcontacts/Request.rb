module GitContacts

  class Request
    class << self

      def exist? request_id
        return true if RequestObject::exist? request_id
      end

      def create hash
        # all keys are required
        if hash.keys == GitContacts::request_keys
          obj = RequestObject.new
          obj.uid = hash[:uid]
          obj.gid = hash[:gid]
          obj.card_id = hash[:card_id]
          obj.action = hash[:action]
          obj.content = hash[:content]
          obj.request_id
        end
      end

      def delete request_id
        return true if RequestObject::delete(request_id) > 0
      end

    end

    def initiazlie request_id
      @obj =  RequestObject::access request_id
    end

    def getuid
      @obj.uid if @obj
    end

    def getgid
      @obj.gid if @obj
    end

    def getaction
      @obj.action if @obj
    end

    def getcard_id
      @obj.card_id if @obj
    end

    def getcontent
      @obj.content if @obj
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
      GitContacts::Request::delete @obj.request_id
    end

  end


  class RequestObject
    include Redis::Objects

    value :uid
    value :gid
    value :card_id
    value :action
    hash_key :content

    def self::key_prefix
      "request_object:"
    end

    def self::exist? id
      true if redis.keys(key_prefix+id+':*').count > 0
    end

    def self::delete id
      redis.del(*(redis.keys(key_prefix+id+':*')))
    end

    def self::access id
      if exist? id
        obj = allocate
        obj.set_id id
        obj.set_uid Redis::Value.new(key_prefix+id+':uid')
        obj.set_gid Redis::Value.new(key_prefix+id+':gid')
        obj.set_card_id Redis::Value.new(key_prefix+id+':card_id')
        obj.set_action Redis::Value.new(key_prefix+id+':action')
        obj.set_content Redis::HashKey.new(key_prefix+id+':content')
        obj
      end
    end


    def initialize
      @id = Digest::SHA1.hexdigest(Time.now.to_s)
    end

    def id
      @id
    end

    def request_id
      @id
    end

    def set_id id
      @id = id
    end

    def set_uid uid
      @uid = uid
    end

    def set_gid gid
      @gid = gid
    end

    def set_card_id card_id
      @card_id = card_id
    end

    def set_action action
      @action = action
    end

    def set_content content
      @content = content
    end

  end

end