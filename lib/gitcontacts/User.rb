module GitContacts

  class User

    def self::exist? email
      UserObject::exist?(email)
    end

    def self::create hash
      # some keys are optional
      obj = UserObject.new
      obj.set_email hash[:email]
      obj.password = Digest::MD5.hexdigest(hash[:password])
    end

    def self::all
      UserObject::all
    end

    def initialize email
      @email = email
      @obj = UserObject::access email
    end

    def getuid
      getemail
    end

    # def getname
    #   @obj.name.value if @obj
    # end

    def getemail
      #@obj.email if @obj
      @email
    end

    def getpassword
      @obj.password.value if @obj
    end

    def getcontacts
      @obj.contacts.members if @obj
    end

    def getrequests
      @obj.requests.members if @obj
    end

    def getinfo
      {
        :uid => getuid,
        :email => getemail,
        :contacts => getcontacts,
        :request => getrequests
      }
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

    #value :uid
    # value :email
    value :password
    set :contacts
    set :requests

    def self::key_prefix
      "user_object:"
    end

    def self::exist? email
      true if redis.keys(key_prefix+email+':*').count > 0
    end

    def self::all
      keys = redis.keys %(#{key_prefix}*:password)
      keys.map { |key| key.split(":")[1] }
    end

    def self::access email
      obj = allocate
      obj.set_email email
      #obj.set_uid Redis::Value.new(key_prefix+obj.id+':uid')
      obj.set_password Redis::Value.new(key_prefix+obj.id+':password')
      obj.set_contacts Redis::Set.new(key_prefix+obj.id+':contacts')
      obj.set_requests Redis::Set.new(key_prefix+obj.id+':requests')
      obj
    end

    def initialize
      #@uid = Digest::SHA1.hexdigest(Time.now.to_s + rand(10000).to_s)
    end

    def id
      @email
    end

    #def set_uid uid
    #  @uid = uid
    #end

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
