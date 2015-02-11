module GitContacts

  class Request
    class << self

      def exist? request_id
        return true if RequestObject::exist?(request_id)
      end

      def create hash
        # all keys are required
        obj = RequestObject.new
        obj.uid = hash[:uid]
        obj.gid = hash[:gid]
        obj.time = Time.now.to_i
        obj.card_id = hash[:card_id] if hash.member? :card_id
        obj.action = hash[:action]
        obj.content = hash[:content] if hash.member? :content
        obj.request_id
      end

      def delete request_id
        return true if RequestObject::delete(request_id) > 0
      end

    end

    def initialize request_id
      @obj =  RequestObject::access request_id
    end

    def getuid
      @obj.uid.value if @obj
    end

    def getgid
      @obj.gid.value if @obj
    end

    def getaction
      @obj.action.value if @obj
    end

    def getcard_id
      @obj.card_id.value if @obj
    end

    def get_req_time
      @obj.time.value if @obj
    end

    def getcontent
      @obj.content.value if @obj
    end

    # code review: @AustinChou
    def auto_merge? uid
      if contacts = Contacts.new(getgid)
        if contacts.getadmins.include? uid
          return true
        else
          case getaction
          when "setdata" ,"delete"
            return true if Gitdb::Card.new(getgid).access(getcard_id).getmeta[:owner] == getuid # to-do
          end
        end
      end
    end

    def allow operator
      author = User.new getuid
      operator = User.new operator
      contacts = Gitdb::Contacts.new(getuid).access getgid
      card = Gitdb::Card.new contacts.repo
      
      case getaction
      when 'create'
        card.create getuid 
      when 'setmeta'
        card.access(getcard_id).setmeta JSON.parse(getcontent, { symbolize_names: true })
      when 'setdata'
        card.access(getcard_id).setdata JSON.parse(getcontent, { symbolize_names: true })
      when 'delete'
        card.access(getcard_id).delete
      end
      
      commit_obj = {
        :author => { :name => author.getuid, :email => author.getemail, :time => Time.at(get_req_time.to_i) },
        :committer => { :name => operator.getuid, :email => operator.getemail, :time => Time.now }
      }

      contacts.make_a_commit commit_obj
      card.getmeta[:id]
    end

    def deny
      # deny merge here
      author = User.new getuid
      author.remove_request @obj.request_id
      Request::delete @obj.request_id
    end
  end


  class RequestObject
    include Redis::Objects

    value :uid
    value :gid
    value :time
    value :card_id
    value :action
    value :content

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
        obj.set_uid Redis::Value.new(key_prefix+obj.id+':uid')
        obj.set_gid Redis::Value.new(key_prefix+obj.id+':gid')
        obj.set_card_id Redis::Value.new(key_prefix+obj.id+':card_id')
        obj.set_action Redis::Value.new(key_prefix+obj.id+':action')
        obj.set_time Redis::Value.new "#{key_prefix}#{obj.id}:time"
        obj.set_content Redis::Value.new(key_prefix+obj.id+':content')
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
