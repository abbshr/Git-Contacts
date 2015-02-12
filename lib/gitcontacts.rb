require 'redis'
require 'redis-objects'

require 'gitcontacts/util'
require 'gitcontacts/User'
require 'gitcontacts/Request'
require 'gitcontacts/Contacts'
require 'gitcontacts/Invitation'
require "gitcontacts/version"
require 'digest'
require "gitdb"

module GitContacts

  @@errno = :ok

  class << self

    def errsym
      @@errno
    end
    
    def user_exist? uid
      User::exist? uid
    end
    
    # code review: @abbshr
    def password_valid? email, password
      User.new(email).password_correct? Digest::MD5.hexdigest(password)
    end
    
    # code review: @AustinChou, @abbshr
    # if operator belongs to contacts gid
    def relation_valid? operator, gid
      Contacts::exist?(gid) && 
      Contacts.new(gid).getusers.include?(operator) && 
      User.new(operator).getcontacts.include?(gid)
    end

    def create_user hash
      return @@errno = :miss_args unless hash.include?(:email) && hash.include?(:password)
      return @@errno = :exist if user_exist?(hash[:email])
      User::create hash
      @@errno = :ok
    end

    def get_a_user operator, uid
      return @@errno = :non_exist unless user_exist? uid
      @@errno = :ok
      User.new(uid).getinfo
    end

    # => [ uid ]
    def get_users operator
      @errno = :ok
      User::all
    end

    # code review: @abbshr
    # e.g.: 获取联系人数量大于200的uid群组
    # meta => :owner, :gid, :count, :name
    # get_contacts_if operator { |contacts| contacts.count > 200 }
    def get_contacts_if operator, &condition
      @@errno = :ok
      user = User.new operator
      contacts = Gitdb::Contacts.new operator
      user.getcontacts.map { |gid| contacts.access(gid).getmeta }.select &condition
    end

    # code review: @abbshr
    def add_contacts operator, name
      return @@errno = :miss_args unless name
      @@errno = :ok
      gid = Contacts.create operator, :name => name
      contacts = Contacts.new gid
      User.new(operator).add_contacts gid
      gid
    end

    # code review: @abbshr
    def edit_contacts_meta operator, gid, meta
      return @@errno = :forbidden unless relation_valid? operator, gid
      return @@errno = :miss_args unless meta
      @@errno = :ok
      contacts = Gitdb::Contacts.new operator
      contacts.access(gid).setmeta meta
      # TODO: check meta
    end

    # code review: @abbshr
    def get_contacts_card operator, gid, cid
      return @@errno = :forbidden unless relation_valid? operator, gid
      contacts = Gitdb::Contacts.new(operator).access(gid)
      card = contacts.get_card_by_id cid
      return @@errno = :non_exist unless card
      @@errno = :ok
      card.getdata.merge! card.getmeta
    end

    # code review: @abbshr
    def get_contacts_cards_by_related operator, gid, keyword
      return @@errno = :forbidden unless relation_valid? operator, gid
      @@errno = :ok
      contacts = Gitdb::Contacts.new operator
      contacts.access(gid).get_cards do |card|
        if card.getmeta[:owner].include?(keyword) || card.getdata.find { |k,v| v.include? keyword }
          card.getdata.merge! card.getmeta 
        end
      end
    end

    # code review: @abbshr
    def get_contacts_history operator, gid
      return @@errno = :forbidden unless relation_valid? operator, gid
      @@errno = :ok
      contacts = Gitdb::Contacts.new operator
      contacts.access(gid).read_change_history do |commit|
        {
          :author => commit.author,
          :operator => commit.committer,
          :mtime => commit.time,
          :oid => commit.oid,
          :message => commit.message
        }
      end
    end

    # code review: @abbshr
    def revert_to operator, gid, oid
      return @@errno = :forbidden unless relation_valid? operator, gid
      return @@errno = :miss_args unless oid
      contacts = Gitdb::Contacts.new(operator).access gid
      return @@errno = :non_exist unless contacts.read_change_history { |commit| commit.oid }.include?(oid)
      @@errno = :ok
      operator = {
        :name => operator,
        :email => User.new(operator).getemail,
        :time => Time.now
      }
      commit = { 
        :author => operator, 
        :committer => operator, 
        :message => "revert to revision #{oid}" 
      }
      contacts.revert_to oid, commit
    end

    # code review: @abbshr
    def add_contacts_card operator, gid, payload
      return @@errno = :forbidden unless relation_valid? operator, gid
      # request id
      qid = Request::create :uid => operator, :gid => gid, :action => "create"
      req = Request.new qid
      if req.auto_merge? operator
        # here should return card_id if success
        cid = req.allow operator
        Request::delete qid
        @@errno = :ok
        return cid
      else
        @@errno = :pend
        User.new(operator).add_request qid
        Contacts.new(gid).add_request qid
      end
    end

    # code review: @abbshr
    def edit_contacts_card operator, gid, cid, payload
      return @@errno = :forbidden unless relation_valid? operator, gid
      return @@errno = :non_exist unless Gitdb::Contacts.new(operator).access(gid).get_card_by_id cid
      hash = {
        :uid => operator, 
        :gid => gid, 
        :action => "setdata", 
        :card_id => cid, 
        :content => JSON.generate(payload)
      }
      qid = Request::create hash
      req = Request.new qid
      if req.auto_merge? operator
        req.allow operator
        Request::delete qid
        @@errno = :ok
      else
        @@errno = :pend
        User.new(operator).add_request qid
        Contacts.new(gid).add_request qid
      end
    end

    # code review: @abbshr
    def delete_contacts_card operator, gid, cid
      return @@errno = :forbidden unless relation_valid? operator, gid
      return @@errno = :non_exist unless Gitdb::Contacts.new(operator).access(gid).get_card_by_id cid
      hash = {
        :uid => operator, 
        :gid => gid, 
        :action => "delete", 
        :card_id => cid
      }
      qid = Request::create hash
      req = Request.new qid
      if req.auto_merge? operator
        req.allow operator
        Request::delete qid
        @@errno = :ok
      else
        @errno = :pend
        User.new(operator).add_request qid
        Contacts.new(gid).add_request qid
      end
    end

    # code review: @abbshr
    def get_contacts_users operator, gid
      return @@errno = :forbidden unless relation_valid? operator, gid
      @@errno = :ok
      Contacts.new(gid).getusers
    end

    def get_contacts_user operator, gid, uid
      return @@errno = :forbidden unless relation_valid? operator, gid
      return @@errno = :non_exist unless user_exist? operator
      @@errno = :ok
      User.new(uid).getinfo
    end

    # code review: @abbshr
    def add_contacts_user operator, gid, uid
      return @@errno = :forbidden unless relation_valid? operator, gid
      return @@errno = :non_exist unless user_exist? uid
      contacts = Contacts.new(gid)
      if contacts.getadmins.include?(operator)
        @@errno = :ok
        contacts.add_user uid unless contacts.getusers.include? uid
        User.new(uid).add_contacts gid
      else
        @@errno = :forbidden
      end
    end

    def remove_contacts_user operator, gid, uid
      return @@errno = :forbidden unless relation_valid? operator, gid
      contacts = Contacts.new(gid)
      admins = contacts.getadmins
      @@errno = :ok
      if admins.include?(operator)
        return @@errno = :forbidden if admins.length < 2 && operator == uid
        contacts.remove_admin uid
        contacts.remove_user uid
      elsif operator == uid
        contacts.remove_user uid
      else
        @@errno = :forbidden
      end
    end

    def get_contacts_user_privileges operator, gid, uid
      return @@errno = :forbidden unless relation_valid? operator, gid
      @@errno = :ok
      Contacts.new(gid).getadmins.include?(uid) ? 'admin' : 'user'
    end
    
    # code review: @AustinChou
    def edit_contacts_user_privileges operator, gid, uid, role
      return @@errno = :forbidden unless relation_valid? operator, gid
      contacts = Contacts.new gid
      admins = contacts.getadmins
      @@errno = :ok
      if admins.include?(operator)
        return @@errno = :forbidden if admins.length < 2 && operator == uid
        case role
        when "admin"
          contacts.add_admin uid unless contacts.getadmins.include? uid
        when "user"
          contacts.remove_admin uid
        else
          @@errno = :bad_args
        end
      else
        @@errno = :forbidden
      end
    end
    
    # code review: @AustinChou
    def get_all_requests operator
      @@errno = :ok
      Contacts.new(gid).getrequests.map { |qid| Request.new qid }
    end

    def get_a_request operator, qid
      @@errno = :ok
      Request.exist?(qid) ? Request.new(qid) : @@errno = :non_exist
    end

    # code review: @AustinChou
    def edit_request_status operator, gid, qid, action
      return @@errno = :non_exist unless Request.exist? qid
      return @@errno = :forbidden unless relation_valid?(operator, gid)
      return @@errno = :forbidden unless Contacts.new(gid).getadmins.include? operator
      @@errno = :ok
      req = Request.new(qid)
      case action
      when "permit"
        req.allow operator
        Request::delete qid
        User.new(req.getuid).remove_request qid
        Contacts.new(gid).remove_request qid
      when "reject"
        Request::delete qid
        User.new(req.getuid).remove_request qid
        Contacts.new(gid).remove_request qid
      else
        @@errno = :bad_args
      end
    end
  end
end
