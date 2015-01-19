module GitContacts

  class Invitation

    def self::exist? invite_id
      return true if InvitationObject.find_by_name invite_id
    end

    def self::create hash

    end

    def self::delete invite_id
    end

    def initialize invite_id
      @obj = InvitationObject.find_by_name invite_id
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

  class InvitationObject < ActiveRecord::Base
    include Redis::Objects

    value :invite_id
    value :uid
    value :gid
    value :inviter_id

  end

end