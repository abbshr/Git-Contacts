module GitContacts

  class Contacts

    def self::exist? gid
      return true if ContactsObject.find_by_name gid
    end

    def self::create gid, hash

    end

    def initialize gid
      @obj = ContactsObject.find_by_name gid
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

  class ContactsObject < ActiveRecord::Base
    include Redis::Objects

    value :name
    value :gid
    set :users
    set :admins
    set :owner

  end

end