require "gitdb/version"

module Gitdb
  
  class Contact
    # create a new contact group
    def initialize name, uid
      @admin = uid
      @gid = #generate a new contact id
    end

    def Contact::set_meta
      
    end

    def Contact::get_meta
      
    end
  end

  class Person
    attr_accessor 
      :first_name, :last_name, :mobile, :tel, 
      :note, :birthday, :address, :uid

    def initialize 
      @user
    end

    def Person::update
    end

    def Person::delete
      
    end

    def Person::
      
    end
  end

end
