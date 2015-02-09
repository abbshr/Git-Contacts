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

  class << self
    def user_exist? uid
      User::exist? uid
    end

    def create_user hash
      User::create hash
    end

    def password_valid? email, password
      if user = User.new(email)
        user if user.password_correct? Digest::MD5.hexdigest(password)
      end
    end

    def relation_valid? operator, gid
      if User::exist?(operator) && Contacts::exist?(gid)
        user = User.new operator
        contacts = Contacts.new gid
        [user, contacts] if user.getcontacts.include?(gid) && contacts.getusers.include?(operator)
      end
    end

    # meta => :owner, :gid, :count, :name
    def get_all_contacts operator
      contacts_arr = []
      user = User.new operator
      contacts = Gitdb::Contacts.new operator
      user.getcontacts.each do |gid|
        return unless GitContacts::relation_valid? operator gid
        contacts.access gid
        contacts_arr << contacts.getmeta
      end
      contacts_arr
    end

    # e.g.: 获取联系人数量大于200的uid群组
    # get_contacts_if { |contacts| contacts.count > 200 }
    def get_contacts_if uid, &condition
      GitContacts::get_all_contacts(uid).select &condition
    end

    def add_contacts operator, name
      #return unless GitContacts::relation_valid? operator gid
      git_contacts = Gitdb::Contacts.new operator 
      git_contacts.create name
      gid = git_contacts.getmeta[:gid]
      Contacts.create gid, name
      contacts = Contacts.new gid
      contacts.add_user operator
      user = User.new operator
      user.add_contacts gid
      gid
    end

    def edit_contacts_meta operator, gid, new_meta
      return unless GitContacts::relation_valid? operator gid
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      contacts.setmeta new_meta
    end

    def get_contacts_card operator, gid, card_id
      return unless GitContacts::relation_valid? operator gid
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      contacts.get_card_by_id card_id
    end

    def get_contacts_cards_by_related operator, gid, keyword
      return unless GitContacts::relation_valid? operator gid
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      contacts.get_cards do |card|
        info = card.getdata
        info if card.getmeta[:owner].include? keyword || info.find { |k| true if info[k].include? keyword }
      end
    end
    
    def get_contacts_history operator, gid
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      contacts.read_change_history do |commit|
        commit_obj = {}
        commit_obj[:author] = commit.author
        commit_obj[:operator] = commit.committer
        commit_obj[:modified_time] = commit.time
        commit_obj[:oid] = commit.oid
        commit_obj[:message] = commit.message
        commit_obj
      end
    end

    def revert_to operator, gid
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      operator = {
        :name => operator,
        :email => User.new(operator).getemail,
        :time => Time.now
      }
      contacts.revert_to oid, { :author => operator, :committer => operator, :message => "revert to revision #{oid}" }
    end

    def add_contacts_card operator, gid, payload
      return unless GitContacts::relation_valid? operator gid
      # request id
      qid = Request::create :uid => operator, :gid => gid, :action => "create", :time => Time.now, :content => payload
      # create a rqeuest
      req = Request.new qid
      if req.auto_merge? operator
        Request::delete qid
        # here should return card_id if success
        return req.allow operator
      end
      true
    end

    def edit_contacts_card operator, gid, card_id, payload
      return unless GitContacts::relation_valid? operator gid
      qid = GCRequest::create :uid => operator, :gid => gid, :action => "setdata", :time => Time.now, :card_id => card_id, :content => payload
      req = GCRequest.new qid
      if req.auto_merge? operator
        req.allow operator
        Request::delete qid
      end
      true
    end

    def delete_contacts_card operator, gid, card_id
      return unless GitContacts::relation_valid? operator gid
      qid = GCRequest::create :uid => operator, :gid => gid, :action => "delete", :time => Time.now, :card_id => card_id
      req = GCRequest.new qid
      if req.auto_merge? operator
        req.allow operator
        Request::delete qid
      end
      true
    end

    def get_contacts_users operator, gid
      return unless result = GitContacts::relation_valid?(operator, gid)
      contacts = result.last
      contacts.getusers
    end

    def add_contacts_user operator, gid, uid
      return unless result = GitContacts::relation_valid?(operator, gid)
      user = result.first
      contacts = result.last
      if contacts.getadmins.include?(user.getuid)
        contacts.add_user uid
        true
      end
    end
    
    def edit_contacts_user_privileges operator, gid, uid, payload
      return unless result = GitContacts::relation_valid?(operator, gid)
      user = result.first
      contacts = result.last
      if contacts.getadmins.include?(user.getuid)
        case payload[:role]
        when "admin"
          contacts.add_admin uid
          true
        when "users"
          contacts.remove_admin uid
          true
        end
      end
    end
=begin
    def invite_contacts_user operator, gid, payload
      return unless result = GitContacts::relation_valid?(operator, gid)
      user = result.first
      contacts = result.last
      if contacts.getadmins.include?(user.getuid)
        Inviation::create :uid => User::email_to_uid(payload[:email]), :contacts => gid
      end
    end

    def edit_invitation_status operator, payload
      invitation = Inviation.new payload[:invite_id]
      if invitation.accept? operator
        user = User.new operator
        gid = invitation.getcontacts
        user.add_contacts gid
        contacts = GCContacts.new gid
        contacts.adduser user.getuid
        Inviation::delete payload[:invite_id]
        true
      end
    end
=end
    def get_all_requests operator
    end

    def edit_request_status operator
    end
  end
end
