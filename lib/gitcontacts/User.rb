module GitContacts

  class User

    def self::exist? email
      return true if UserObject::exist? email
    end

    def self::create hash
      # some keys are optional
      if hash.keys.include? :name && hash.keys.include? :password
        obj = UserObject.new
        obj.name = hash[:name]
        obj.password = hash[:password]
        obj.uid
      end
    end

    def initialize email
      @obj = UserObject::access email
    end

    def getuid
      @obj.uid if @obj
    end

    def getpassword
      @obj.password if @obj
    end

    def getcontacts
      @obj.contacts if @obj
    end

    def getrequests
      @obj.requests if @obj
    end

    def password_correct? sha
      sha == getpassword && sha != nil && sha != ""
    end

    def set_password sha
      @obj.password = sha if sha != nil && sha != ""
    end

    def add_contacts gid
      @obj.contacts << gid if @obj
    end

    def remove_contacts gid
      @obj.contacts.delete(gid) if @obj
    end

    def add_request request_id
      @obj.requests << request_id if @obj
    end

    def remove_request request_id
      @obj.requests.delete(request_id) if @obj
    end

  end

  class UserObject
    include Redis::Objects

    value :uid
    value :password
    set :contacts
    set :requests

    def self::key_prefix
      "user_object:"
    end

    def self::exist? id
      true if redis.keys(key_prefix+id+':*').count > 0
    end

    def self::access id
      if exist? id
        obj = allocate
        obj.set_id id
        obj.set_uid Redis::Value.new(key_prefix+id+':uid')
        obj.set_password Redis::Value.new(key_prefix+id+':password')
        obj.set_contacts Redis::Set.new(key_prefix+id+':contacts')
        obj.set_requests Redis::Set.new(key_prefix+id+':requests')
        obj
      end
    end

    def initialize
      @id = Digest::SHA1.hexdigest(Time.now.to_s)
    end

    def id
      @id
    end

    def email
      @id
    end

    def set_id id
      @id = id
    end

    def set_uid uid
      @uid = uid
    end

    def set_password password
      @password = password
    end

    def set_contacts contacts
      @contacts = contacts
    end

    def set_requests requests
      @requests = requests
    end

  end

end