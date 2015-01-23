module GitContacts

  class User

    def self::exist? email
      true if UserObject::exist?(email)
    end

    def self::create hash
      # some keys are optional
      if hash.keys.include?(:email) && hash.keys.include?(:password) && !User::exist? hash[:email]
        obj = UserObject.new
        obj.email = hash[:email]
        obj.password = hash[:password]
        obj.uid
      else
        nil
      end
    end

    def initialize uid
      @obj = UserObject::access uid
    end

    def getuid
      @obj.uid if @obj
    end

    def getname
      @obj.name if @obj
    end

    def getemail
      @obj.email if @obj
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
      @obj.contacts.delete gid if @obj
    end

    def add_request request_id
      @obj.requests << request_id if @obj
    end

    def remove_request request_id
      @obj.requests.delete request_id if @obj
    end

  end

  class UserObject
    include Redis::Objects

    value :uid
    value :email
    value :password
    set :contacts
    set :requests

    def self::key_prefix
      "user_object:"
    end

    def self::exist? email
      true if redis.keys(key_prefix+email+':*').count > 0
    end

    def self::access uid
      obj = allocate
      obj.set_uid uid
      obj.set_email Redis::Value.new(key_prefix+id+':email')
      obj.set_password Redis::Value.new(key_prefix+id+':password')
      obj.set_contacts Redis::Set.new(key_prefix+id+':contacts')
      obj.set_requests Redis::Set.new(key_prefix+id+':requests')
      obj
    end

    def initialize
      @uid = Digest::SHA1.hexdigest(Time.now.to_s + rand 10000)
    end

    def id
      @email
    end

    def set_uid uid
      @uid = uid
    end

    def set_email email
      @email = email
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
