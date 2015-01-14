require './GCUser.rb'
require './GCRequest.rb'
require './GCContacts.rb'
require './GCInviation.rb'
require 'digest/sha1'

module GCService

  def self::user_exist? email
    GCUser::exist? email
  end

  def self::create_user email, hash
    GCUser::create email, hash
  end

  def self::password_valid email, password
    if user = GCUser.new email
      user.password_correct? Digest::SHA1.hexdigest password
    end
  end

  def self::relation_valid? operator gid
    if GCUser::operator_exist? operator && GCContacts::exist? gid
      user = GCUser.new(GCUser::operator_to_email operator)
      contacts = GCContacts.new gid
      return [user, contacts] if user.getcontacts.include? gid && contacts.getusers.include? operator
    end
  end

  def self::get_all_contacts operator
    contacts_arr = []
    user = GCUser.new operator
    contacts = Gitdb::Contacts.new operator
    user.getcontacts.each do |gid|
      if GCService::relation_valid? operator gid
        contacts.access gid
        contacts_arr << contacts.getmeta
      end
    end
    contacts_arr
  end

  def self::add_contacts operator
    # to-do
  end

  def self::edit_contacts_meta operator
    # to-do
  end

  def self::get_contacts_all_cards operator gid
    cards_arr = []
    if GCService::relation_valid? operator gid
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      contacts.get_all_cards.each do |card|
        cards_arr << card.getdata
      end
    end
    cards_arr
  end

  def self::get_contacts_card operator gid card_id
    if GCService::relation_valid? operator gid
      contacts = Gitdb::Contacts.new operator
      contacts.access gid
      if card = contacts.get_card_by_id card_id
        card.getdata
      end
    end
  end

  def self::add_contacts_card operator gid payload
    if GCService::relation_valid? operator gid
      qid = GCRequest::create :uid => operator, :gid => gid, :action => "add", :content => payload
      req = GCRequest.new qid
      if req.can_auto_merge operator
        req.merge
        GCRequest::delete qid
      end
      # here should return card_id if success
    end
  end

  def self::edit_contacts_card operator gid card_id payload
    if GCService::relation_valid? operator gid
      qid = GCRequest::create :uid => operator, :gid => gid, :action => "edit", :card_id => card_id, :content => payload
      req = GCRequest.new qid
      if req.can_auto_merge operator
        req.merge
        GCRequest::delete qid
      end
      true
    end
  end

  def self::delete_contacts_card operator
    if GCService::relation_valid? operator gid
      qid = GCRequest::create :uid => operator, :gid => gid, :action => "delete"
      req = GCRequest.new qid
      if req.can_auto_merge operator
        req.merge
        GCRequest::delete qid
      end
      true
    end
  end

  def self::get_contacts_users operator gid
    if result = GCService::relation_valid? operator gid
      contacts = result.last
      contacts.getusers
    end
  end

  def self::add_contacts_user operator gid uid
    if result = GCService::relation_valid? operator gid
      user = result.first
      contacts = result.last
      if contacts.getadmins.include?(user.getuid)
        contacts.add_user uid
        true
      end
    end
  end
  
  def self::edit_contacts_user_privileges operator gid uid payload
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

  def self::invite_contacts_user operator gid payload
    if result = GCService::relation_valid? operator gid
      user = result.first
      contacts = result.last
      if contacts.getadmins.include?(user.getuid)
        GCInviation::create :uid => GCUser::email_to_uid(payload[:email]), :contacts => gid #["uid", "contacts"]
      end
    end
  end

  def self::edit_invitation_status operator payload
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

  def self::get_all_requests operator

  end

  def self::edit_request_status operator

end
