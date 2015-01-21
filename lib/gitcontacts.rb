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
      GCUser::exist? email
    end

    def create_user email, hash
      GCUser::create email, hash
    end

    def password_valid email, password
      if user = GCUser.new email
        user.password_correct? Digest::SHA1.hexdigest password
      end
    end

    def relation_valid? operator gid
      if GCUser::operator_exist? operator && GCContacts::exist? gid
        user = GCUser.new(GCUser::operator_to_email operator)
        contacts = GitContacts.new gid
        return [user, contacts] if user.getcontacts.include? gid && contacts.getusers.include? operator
      end
    end

    # meta => :owner, :gid, :count, :name
    def get_all_contacts uid
      contacts_arr = []
      user = GCUser.new operator
      contacts = Gitdb::Contacts.new uid
      user.getcontacts.each do |gid|
        if GitContacts::relation_valid? operator gid
          contacts.access gid
          contacts_arr << contacts.getmeta
        end
      end
      contacts_arr
    end

    # e.g.: 获取联系人数量大于200的uid群组
    # get_contacts_if { |contacts| contacts.count > 200 }
    def get_contacts_if &condition
      GitContacts::get_all_contacts(uid).select &condition
    end

    def add_contacts operator
      # to-do
      contacts = Gitdb::Contacts.new uid
      contacts.create contacts_name
    end

    def edit_contacts_meta operator
      # to-do
      contacts = Gitdb::Contacts.new uid
      contacts.access gid
      contacts.setmeta new_meta
    end

    def get_contacts_all_cards operator gid
      unless GCService::relation_valid? operator gid
        return 'deny'
      end
      contacts = Gitdb::Contacts.new uid
      contacts.access gid
      contacts.get_cards do |card|
        card.getdata
      end
    end

    def get_contacts_card operator gid card_id
      if GCService::relation_valid? operator gid
        contacts = Gitdb::Contacts.new uid
        contacts.access gid
        contacts.get_card_by_id card_id
      end
    end

    def get_contacts_cards_by_owner owner
      contacts = Gitdb::Contacts.new uid
      contacts.access gid
      contacts.get_cards do |card|
        card.getdata if card.getmeta[:owner].include? owner
      end
    end

    def get_contacts_cards_by_name name 
      contacts = Gitdb::Contacts.new uid
      contacts.access gid
      contacts.get_cards do |card|
        card.getdata if card.getdata[:firstname].include? name || card.getdata[:firstname].include? name
      end
    end

    def get_contacts_cards_by_number number
      contacts = Gitdb::Contacts.new uid
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

    def get_contacts_cards_by_related keyword
      contacts = Gitdb::Contacts.new uid
      contacts.access gid
      contacts.get_cards do |card|
        info = card.getdata
        info if card.getmeta[:owner].include? keyword || info.find { |k| true if info[k].include? keyword }
      end
    end
    
    def get_contacts_history
      contacts = Gitdb::Contacts.new uid
      contacts.access gid
      contacts.read_modify_history.each do |commit|
        author = commit.author
        operator = commit.committer
        modify_time = commit.
        oid = commit.oid
      end
    end

    def revert_to oid, operator_id
      operator = {
        :name => operator_id,
        :email => ,
        :time => Time.now
      }
      contacts = Gitdb::Contacts.new uid
      contacts.access gid
      contacts.revert_to oid, { :author => operator, :committer => operator, :message => "revert to revision #{oid}" }
      get_contacts_all_cards
    end

    def add_contacts_card operator gid payload
      unless GCService::relation_valid? operator gid
        return 'deny'
      end
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

    def edit_contacts_card operator gid card_id payload
      if GCService::relation_valid? operator gid
        qid = GCRequest::create :uid => operator, :gid => gid, :action => "setdata", :time => Time.now :card_id => card_id, :content => payload
        req = GCRequest.new qid
        if req.auto_merge? operator
          req.allow operator
          Request::delete qid
          # here should return card_id if success
        end
        true
      end
    end

    def delete_contacts_card operator
      if GCService::relation_valid? operator gid
        qid = GCRequest::create :uid => operator, :gid => gid, :action => "delete", :time => Time.now
        req = GCRequest.new qid
        if req.auto_merge? operator
          req.allow operator
          Request::delete qid
        end
        true
      end
    end

    def get_contacts_users operator gid
      if result = GCService::relation_valid? operator gid
        contacts = result.last
        contacts.getusers
      end
    end

    def add_contacts_user operator gid uid
      if result = GCService::relation_valid? operator gid
        user = result.first
        contacts = result.last
        if contacts.getadmins.include?(user.getuid)
          contacts.add_user uid
          true
        end
      end
    end
    
    def edit_contacts_user_privileges operator gid uid payload
      if result = GCService::relation_valid? operator gid
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

    def invite_contacts_user operator gid payload
      if result = GCService::relation_valid? operator gid
        user = result.first
        contacts = result.last
        if contacts.getadmins.include?(user.getuid)
          GCInviation::create :uid => GCUser::email_to_uid(payload[:email]), :contacts => gid #["uid", "contacts"]
        end
      end
    end

    def edit_invitation_status operator payload
      invitation = GCInviation.new(payload[:invite_id])
      if invitation.can_accept? operator
        user = GCUser.new operator
        gid = invitation.getcontacts
        user.add_contacts gid
        contacts = GCContacts.new gid
        contacts.adduser user.getuid
        GCInviation::delete payload[:invite_id]
        true
      end
    end

    def get_all_requests operator
    end

    def edit_request_status operator
    end
  end
end
