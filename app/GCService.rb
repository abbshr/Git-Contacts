require './GCUser.rb'
require './GCRequest.rb'
require './GCContacts.rb'
require './GCInviation.rb'

module GCService

  def self::user_exist? email

  end

  def self::create_user hash

  end

  def self::password_valid email, password

  end

  def self::add_contacts uid

  end

  def self::edit_contacts_meta uid

  end

  def self::get_contacts_all_cards uid

  end

  def self::get_contacts_card uid

  end

  def self::add_contacts_card uid

  end

  def self::edit_contacts_card uid

  end

  def self::delete_contacts_card uid

  end

  def self::get_contacts_users uid

  end

  def self::add_contacts_user uid

  end
  
  def self::edit_contacts_user_privileges uid

  end

  def self::invite_contacts_user uid

  end

  def self::edit_invitation_status uid

  end

  def self::get_all_requests uid

  end

  def self::edit_request_status uid

end
