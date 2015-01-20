module GitContacts

  class Invitation

    def self::exist? invite_id
      return true if InvitationObject::exist? invite_id
    end

    def self::create hash

    end

    def self::delete invite_id
    end

    def initialize invite_id
      @obj = InvitationObject::access invite_id
    end

    def getuid
      @obj.uid if @obj
    end

    def getgid
      @obj.gid if @obj
    end

    def getinviter_id
      @obj.inviter_id
    end

    def can_accept? uid
      uid == getuid
    end

    def accept
       
    end

  end

  # class InvitationObject < ::Base
  #   include Redis::Objects

  #   value :invite_id
  #   value :uid
  #   value :gid
  #   value :inviter_id

  # end

  class InvitationObject
    include Redis::Objects

    value :uid
    value :gid
    value :inviter_id

    def self::key_prefix
      "invitation_object:"
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
        obj.set_inviter_id Redis::Value.new(key_prefix+id+':inviter_id')
        obj
      end
    end


    def initialize
      @id = Digest::SHA1.hexdigest(Time.now.to_s)
    end

    def id
      @id
    end

    def invite_id
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

    def set_inviter_id inviter_id
      @inviter_id = inviter_id
    end

  end

end