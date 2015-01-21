module GitContacts

  class Request
    class << self
      def exist? request_id
        return true if RequestObject.find_by_name request_id
      end
      def create hash

      end

      def delete request_id
      
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

    def get_req_time
      @obj.time if @obj
    end

    def getcontent
      @obj.content if @obj
    end

    def auto_merge? uid
      false
    end

    def allow operator
      author = User.new getuid
      contacts = Gitdb::Contacts.new(uid).access getgid
      card = Gitdb::Card.new(contacts.repo)
      
      case getaction
      when 'create'
        card.create uid 
      when 'setmeta'
        card.access(getcard_id).setmeta getcontent
      when 'setdata'
        card.access(getcard_id).setdata getcontent
      when 'delete'
        card.access(getcard_id).delete
      end
      
      commit_obj = {
        :author => { :name => author.getuid, :email => author.getemail, :time => get_req_time },
        :committer => { :name => operator.getuid, :email => operator.getemail, :time => Time.now }
      }

      contacts.make_a_commit commit_obj
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
    value :time
    value :card_id
    value :action
    hash_key :content

    def self::key_prefix
      "request_object:"
    end

    def self::exist? id
      true if redis.keys(key_prefix+id+'*').count > 0
    end

    def self::access id
      if exist? id
        obj = allocate
        obj.set_id id
        obj.set_uid Redis::Value.new(key_prefix+id+':uid')
        obj.set_gid Redis::Value.new(key_prefix+id+':gid')
        obj.set_card_id Redis::Value.new(key_prefix+id+':card_id')
        obj.set_action Redis::Value.new(key_prefix+id+':action')
        obj.set_time Redis::Value.new "#{key_prefix}#{id}:time"
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

    def set_time time
      @time = time
    end

    def set_action action
      @action = action
    end

    def set_content content
      @content = content
    end

  end

end