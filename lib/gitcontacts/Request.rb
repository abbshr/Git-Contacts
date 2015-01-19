module GitContacts

  class Request

    def self::exist? request_id
      return true if RequestObject.find_by_name request_id
    end

    def self::create hash

    end

    def self::delete request_id
    
    end

    def initiazlie request_id
      @obj =  RequestObject.find_by_name request_id
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

  class RequestObject < ActiveRecord::Base
    include Redis::Objects

    value :request_id
    value :uid
    value :gid
    value :card_id
    value :action
    hash_key :content

  end

end