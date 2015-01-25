module GitContacts

  class Contacts

    def self::exist? gid
      true if ContactsObject::exist?(gid)
    end

    def self::create gid, hash
      # some keys are optional
      if hash.keys.include?(:name)
        obj = ContactsObject.new
        obj.name = hash[:name]
        obj.note = hash[:note] if hash.has_key?(:note)
        obj.users << gid
        obj.admins << gid
        obj.gid
      end
    end

    def initialize gid
      @obj = ContactsObject::access gid
    end

    def getgid
      @obj.gid if @obj
    end

    def getusers
      @obj.users if @obj
    end

    def getadmins
      @obj.admins if @obj
    end

    def add_user uid
      @obj.users << uid if @obj
    end

    def add_admin uid
      @obj.admins << uid if @obj
    end

    def remove_user uid
      @obj.users.delete(uid) if @obj
    end

    def remove_admin uid
      @obj.admins.delete(uid) if @obj
    end
    
  end

  class ContactsObject
    include Redis::Objects

    value :name
    value :note
    set :users
    set :admins
    set :requests
    value :owner

    def self::key_prefix
      "contacts_object:"
    end

    def self::exist? id
      true if redis.keys(key_prefix+id+':*').count > 0
    end

    def self::access id
      if exist? id
        obj = allocate
        obj.set_id id
        obj.set_name Redis::Value.new(key_prefix+obj.id+':name')
        obj.set_note Redis::Value.new(key_prefix+obj.id+':note')
        obj.set_users Redis::Set.new(key_prefix+obj.id+':users')
        obj.set_admins Redis::Set.new(key_prefix+obj.id+':admins')
        obj.set_requests Redis::Set.new(key_prefix+obj.id+':requests')
        obj.set_owner Redis::Value.new(key_prefix+obj.id+':owner')
        obj
      end
    end


    def initialize
      @id = Digest::SHA1.hexdigest Time.now.to_s
    end

    def id
      @id
    end

    def gid
      @id
    end

    def set_id id
      @id = id
    end

    def set_name name
      @name = name
    end

    def set_note note
      @note = note
    end

    def set_users users
      @users = users
    end

    def set_admins admins
      @admins = admins
    end

    def set_requests requests
      @requests = requests
    end

    def set_owner owner
      @owner = owner
    end

  end

end