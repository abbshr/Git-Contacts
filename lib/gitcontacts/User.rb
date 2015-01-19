module GitContacts

  class User

    def self::exist? email
      return true if UserObject.find_by_name email
    end

    def self::create hash

    end

    def initialize email
      @obj = UserObject.find_by_name email
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
      sha == getpassword
    end

    def set_password 
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

  class UserObject < ActiveRecord::Base
    include Redis::Objects

    value :email
    value :uid
    value :password
    set :contacts
    set :requests

  end

end