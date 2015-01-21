require 'redis'
require 'redis-objects'

require 'gitcontacts/util'
require 'gitcontacts/User'
require 'gitcontacts/Request'
require 'gitcontacts/Contacts'
require 'gitcontacts/Inviation'
require "gitcontacts/version"
require 'digest/sha1'
require "gitdb"

module GitContacts

  class << self
    def user_exist? email
      User::exist? email
    end

    def create_user hash
      User::create hash
    end

    def password_valid email, password
      if user = User.new email
        user.password_correct? Digest::SHA1.hexdigest password
      end
    end

    def relation_valid? operator gid
      if User::exist? operator && Contacts::exist? gid
        user = User.new()
        contacts = GitContacts.new gid
        [user, contacts] if user.getcontacts.include? gid && contacts.getusers.include? operator
      end
    end

    # meta => :owner, :gid, :count, :name
    def get_all_contacts operator
      contacts_arr = []
      user = User.new operator
      contacts = Gitdb::Contacts.new uid
      user.getcontacts.each do |gid|
        return unless GitContacts::relation_valid? operator gid
        contacts.access gid
        contacts_arr << contacts.getmeta
      end
      contacts_arr
    end

    # e.g.: 获取联系人数量大于200的uid群组
    # get_contacts_if { |contacts| contacts.count > 200 }
    def get_contacts_if &condition
      GitContacts::get_all_contacts(uid).select &condition
    end

    def add_contacts operator, gid, name
      return unless GitContacts::relation_valid? operator gid
      contacts = Gitdb::Contacts.new operator
      contacts.create name
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
=begin
    def get_contacts_cards_by_owner operator, owner
      return unless GitContacts::relation_valid? operator gid
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      contacts.get_cards do |card|
        card.getdata if card.getmeta[:owner].include? owner
      end
    end

    def get_contacts_cards_by_name operator, name 
      return unless GitContacts::relation_valid? operator gid
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      contacts.get_cards do |card|
        card.getdata if card.getdata[:firstname].include? name || card.getdata[:firstname].include? name
      end
    end

    def get_contacts_cards_by_number operator, number
      return unless GitContacts::relation_valid? operator gid
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      contacts.get_cards do |card|
        info = card.getdata
        cond = info[:mobile].include? number || info[:phone].include? number || info[:im].include? number
        info if cond
      end
    end

    def get_contacts_cards_by_birthday date
      contacts = Gitdb::Contacts.new uid
      contacts.access gid
      contacts.get_cards do |card|
        card.getdata if card.getdata[:birthday].include? date
      end
    end

    def get_contacts_cards_by_email email
      contacts = Gitdb::Contacts.new uid
      contacts.access gid
      contacts.get_cards do |card|
        card.getdata if card.getdata[:email].include? email
      end
    end

    def get_contacts_cards_by_etc info
      contacts = Gitdb::Contacts.new uid
      contacts.access gid
      contacts.get_cards do |card|
        card.getdata if card.getdata[:address].include? info || card.getdata[:note].include? info
      end
    end
=end
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

    def revert_to operator
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      operator = {
        :name => operator,
        :email => ,
        :time => Time.now
      }
      contacts.revert_to oid, { :author => operator, :committer => operator, :message => "revert to revision #{oid}" }
    end

    def add_contacts_card operator, gid, payload
      return unless GitContacts::relation_valid? operator gid
      # request id
      qid = Request::create :uid => operator, :gid => gid, :action => "create", :time => Time.now :content => payload
      # create a rqeuest
      req = Request.new qid
      if req.auto_merge? operator
        req.allow operator
        Request::delete qid
        # here should return card_id if success
      end
    end

    def edit_contacts_card operator, gid, card_id, payload
      return unless GitContacts::relation_valid? operator gid
      qid = GCRequest::create :uid => operator, :gid => gid, :action => "setdata", :time => Time.now :card_id => card_id, :content => payload
      req = GCRequest.new qid
      if req.auto_merge? operator
        req.allow operator
        Request::delete qid
      end
    end

    def delete_contacts_card operator, gid
      return unless GitContacts::relation_valid? operator gid
      qid = GCRequest::create :uid => operator, :gid => gid, :action => "delete", :time => Time.now
      req = GCRequest.new qid
      if req.auto_merge? operator
        req.allow operator
        Request::delete qid
      end
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

    def get_all_requests operator
    end

    def edit_request_status operator
    end
  end
end
