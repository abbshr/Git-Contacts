require 'rake'
require 'rest-client'
require 'json'

@last_response = nil # this variable is used to store last response in order to use in later api calls

desc "Test Web Service RESTful APIs"
task :test_all, [:email, :password] do |t, args|

end


namespace 'test_func' do

  # all functions may vary in future

  desc "post /register api test function"
  task :post_register, [:email, :password] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:email, :password]
    request_uri = generateURL request_uri: '/register'
    data = {
      "email" => args[:email],
      "password" => args[:password]
    }
    code, result, @last_response = performPOST(request_uri, data.to_json)
    puts "post /register return #{result} with status #{code}"
  end


  desc "post /login api test function"
  task :post_login, [:email, :password] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:email, :password]
    request_uri = generateURL request_uri: '/login'
    data = {
      "email" => args[:email],
      "password" => args[:password]
    }
    code, result, @last_response = performPOST(request_uri, data.to_json)
    puts "post /login return #{result} with status #{code}"
  end


  desc "get /logout api test function"
  task :get_logout, [:cookies] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies]
    request_uri = generateURL request_uri: '/logout'
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /logout return #{result} with status #{code}"
  end


  desc "get /contacts/:contacts_id/users api test function"
  task :get_contacts_users, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/users"
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts/:contacts_id/users return #{result} with status #{code}"
  end

  desc "delete /contacts/:contacts_id/user/:user_id api test function"
  task :delete_contacts_user, [:cookies, :contacts_id, :user_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id, :user_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/user/#{args[:user_id]}"
    code, result, @last_response = performDELETE(request_uri, {}, args[:cookies])
    puts "delete /contacts/:contacts_id/user/:user_id return #{result} with status #{code}"
  end

  desc "put /contacts/:contacts_id/user/:user_id/privilege api test function"
  task :put_contacts_user_privilege, [:cookies, :contacts_id, :user_id, :role] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id, :user_id, :role]
    data = {
      "role" => args[:role]
    }
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/user/#{args[:user_id]}/privilege"
    code, result, @last_response = performPUT(request_uri, data.to_json, args[:cookies])
    puts "put /contacts/:contacts_id/user/:user_id/privilege return #{result} with status #{code}"
  end

  desc "get /contacts api test function"
  task :get_contacts, [:cookies] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies]
    request_uri = generateURL request_uri: '/contacts'
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts return #{result} with status #{code}"
  end


  desc "post /contacts api test function"
  task :post_contacts, [:cookies] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies]
    request_uri = generateURL request_uri: '/contacts'
    data = {
      "contacts_name" => "TEST CONTACTS"
    }
    code, result, @last_response = performPOST(request_uri, data.to_json, args[:cookies])
    puts "post /contacts return #{result} with status #{code}"
  end

  desc "get /contacts/:contacts_id/cards api test function"
  task :get_contacts_cards, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/cards"
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts/:contacts_id/cards return #{result} with status #{code}"
  end


  desc "get /contacts/:contacts_id/card/:card_id api test function"
  task :get_contacts_card_by_id, [:cookies, :contacts_id, :card_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id, :card_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/card/#{args[:card_id]}"
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts/:contacts_id/card/:card_id return #{result} with status #{code}"
  end


  desc "post /contacts/:contacts_id/card api test function"
  task :post_contacts_card, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/card"
    data = {
      # to-do
    }
    code, result, @last_response = performPOST(request_uri, data.to_json, args[:cookies])
    puts "post /contacts/:contacts_id/card return #{result} with status #{code}"
  end


  desc "put /contacts/:contacts_id/card/:card_id api test function"
  task :put_contacts_card_by_id, [:cookies, :contacts_id, :card_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id, :card_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/card/#{args[:card_id]}}"
    data = {
      # to-do
    }
    code, result, @last_response = performPUT(request_uri, data.to_json, args[:cookies])
    puts "put /contacts/:contacts_id/card/:card_id return #{result} with status #{code}"
  end


  desc "delete /contacts/:contacts_id/card/:card_id api test function"
  task :delete_contacts_card_by_id, [:cookies, :contacts_id, :card_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id, :card_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/card/#{args[:card_id]}}"
    code, result, @last_response = performDELETE(request_uri, {}, args[:cookies])
    puts "delete /contacts/:contacts_id/card/:card_id return #{result} with status #{code}"
  end


  desc "put /contacts/:contacts_id/metadata api test function"
  task :put_contacts_metadata, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id]
    data = {
      "contacts_name" => "TEST CONTACTS NEW"
    }
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/metadata"
    code, result, @last_response = performPUT(request_uri, data.to_json, args[:cookies])
    puts "put /contacts/:contacts_id/metadata return #{result} with status #{code}"
  end

  desc "get /contacts/:contacts_id/history api test function"
  task :get_contacts_history, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/history"
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts/:contacts_id/history return #{result} with status #{code}"
  end


  desc "post /contacts/:contacts_id/history api test function"
  task :post_contacts_history, [:cookies, :contacts_id, :commit_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id, :commit_id]
    data = {
      "oid" => args[:commit_id]
    }
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/history"
    code, result, @last_response = performPOST(request_uri, data.to_json, args[:cookies])
    puts "post /contacts/:contacts_id/history return #{result} with status #{code}"
  end


  desc "post /contacts/:contacts_id/invitation api test function"
  task :post_contacts_invitation, [:cookies, :contacts_id, :email] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id, :email]
    data = {
      "email" => args[:email]
    }
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/invitation"
    code, result, @last_response = performPOST(request_uri, data.to_json, args[:cookies])
    puts "post /contacts/:contacts_id/invitation return #{result} with status #{code}"
  end

  desc "put /invitation api test function"
  task :put_invitation, [:cookies, :invite_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :invite_id]
    data = {
      "invite_id" => args[:invite_id]
    }
    request_uri = generateURL request_uri: "/invitation"
    code, result, @last_response = performPUT(request_uri, data.to_json, args[:cookies])
    puts "put /invitation return #{result} with status #{code}"
  end

  desc "get /contacts/:contacts_id/requests api test function"
  task :get_contacts_requests, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/requests"
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts/:contacts_id/requests return #{result} with status #{code}"
  end

  desc "put /contacts/:contacts_id/request/:request_id/status api test function"
  task :put_contacts_request_status, [:cookies, :contacts_id, :request_id, :action] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym } == [:cookies, :contacts_id, :request_id, :action]
    data = {
      "action" => args[:action]
    }
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/request/#{args[:request_id]}/status"
    code, result, @last_response = performPUT(request_uri, data.to_json, args[:cookies])
    puts "put /contacts/:contacts_id/request/:request_id/status return #{result} with status #{code}"
  end

end

namespace 'test' do


  desc "register"
  task :register, [:email, :password] do |t, args|
    # perform register
    data = {
      "email" => "testuser"+rand(10000)+to_s,
      "password" => "1q2w3e4r"
    }.merge(args.to_hash)
    Rake::Task["test_func:post_register"].invoke(data["email"], data["password"])
    code, result = parseResponse(@last_response)
    raise "register failed" unless code == 200 && result[:success].to_s == '1'
    # register sucessfully
    # perform login
    Rake::Task["test_func:post_login"].invoke(data["email"], data["password"])
    code, result = parseResponse(@last_response)
    if code == 200 && result[:success].to_s == '1'
      puts "test register passed."
    else
      puts "test register failed."
    end
  end

  desc "register duplicated"
  task :register_duplicated, [:email, :password] do |t, args|
    # perform register
    data = {
      "email" => "testuser"+rand(10000)+to_s,
      "password" => "1q2w3e4r"
    }.merge(args.to_hash)
    Rake::Task["test_func:post_register"].invoke(data["email"], data["password"])
    code, result = parseResponse(@last_response)
    raise "register failed" unless code == 200 && result[:success].to_s == '1'
    # register sucessfully
    # perform register again
    Rake::Task["test_func:post_register"].invoke(data["email"], data["password"])
    code, result = parseResponse(@last_response)
    if code == 409 && result[:errmsg].to_s == "Create user failed."
      puts "test register duplicated passed."
    else
      puts "test register duplicated failed."
    end
  end 

  desc "logout"
  task :logout, [:email, :password] do |t, args|
    # perform register
    data = {
      "email" => "testuser"+rand(10000)+to_s,
      "password" => "1q2w3e4r"
    }.merge(args.to_hash)
    Rake::Task["test_func:post_register"].invoke(data["email"], data["password"])
    code, result, cookies = parseResponse(@last_response)
    raise "register failed" unless code == 200 && result[:success].to_s == '1'
    # register sucessfully
    # perform logout
    Rake::Task["test_func:get_logout"].invoke(cookies)
    code, result = parseResponse(@last_response)
    if code == 200 && result[:success].to_s == '1'
      puts "test logout passed."
    else
      puts "test logout failed."
    end
  end

  desc "add contacts book"
  task :add_contacts, [:email, :password] do |t, args|
    # perform login
    raise "arguments not enough" unless args.to_hash.keys.map { |k| k.to_sym } == [:email, :password]

    Rake::Task["test_func:post_login"].invoke(args["email"], args["password"])
    code, result, cookies = parseResponse(@last_response)
    raise "login failed" unless code == 200 && result[:success].to_s == '1'
    # login successfully
    # perform post contacts
    Rake::Task["test_func:post_contacts"].invoke(cookies)
    code, result = parseResponse(@last_response)
    raise "post contacts failed" unless code == 200 && result[:success].to_s == '1'
    # post successfully
    # perform get contacts metadata
    Rake::Task["test_func:get_contacts_metadata"].invoke(cookies, result[:contacts_id])
    code, result = parseResponse(@last_response)
    raise "get contacts failed" unless code == 200 && result[:success].to_s == '1'
    # get contacts metadata successfully
    # assert contacts name equal
    if result[:contacts_name] == "TEST CONTACTS" # pre-defined
      puts "test add contacts passed."
    else
      puts "test add contacts failed."
    end
  end

  desc "update contacts metadata"
  task :update_contacts_metadata, [:email, :password, :contacts_id] do |t, args|
    # perform login
    raise "arguments not enough" unless args.to_hash.keys.map { |k| k.to_sym } == [:email, :password]

    Rake::Task["test_func:post_login"].invoke(args["email"], args["password"])
    code, result, cookies = parseResponse(@last_response)
    raise "login failed" unless code == 200 && result[:success].to_s == '1'
    # login successfully
    # perform get contacts metadata
    Rake::Task["test_func:get_contacts_metadata"].invoke(cookies, args["contacts_id"])
    code, result = parseResponse(@last_response)
    raise "get contacts failed" unless code == 200 && result[:success].to_s == '1'
    # get contacts metadata successfully
    # perform put contacts metadata
    Rake::Task["test_func:put_contacts_metadata"].invoke(cookies, args["contacts_id"])
    code, result = parseResponse(@last_response)
    raise "login failed" unless code == 200 && result[:success].to_s == '1'
    # puts contacts meta successfully
    # perform get contacts metadata
    Rake::Task["test_func:get_contacts_metadata"].invoke(cookies, args["contacts_id"])
    code, result = parseResponse(@last_response)
    raise "get contacts failed" unless code == 200 && result[:success].to_s == '1'
    # get contacts meta successfully
    # assert contacts name equal
    if result[:contacts_name] == "TEST CONTACTS NEW"
      puts "update contacts metadata passed."
    else
      puts "update contacts metadata failed."
    end
  end

  desc "add contacts card"
  task :add_contacts_card, [:email, :password, :contacts_id] do |t, args|
    # perform login
    raise "arguments not enough" unless args.to_hash.keys.map { |k| k.to_sym } == [:email, :password]

    Rake::Task["test_func:post_login"].invoke(args["email"], args["password"])
    code, result, cookies = parseResponse(@last_response)
    raise "login failed" unless code == 200 && result[:success].to_s == '1'
    # login successfully
    # perform check user privilege
    Rake::Task["test_func:get_contacts_user_privilege"].invoke(cookies, args["contacts_id"])
    code, result = parseResponse(@last_response)
    raise "get privilege failed" unless code == 200 && result[:success].to_s == '1'
    role = result[:role]
    # check user privilege successfully
    # perform get contacts metadata
    Rake::Task["test_func:get_contacts_metadata"].invoke(cookies, args["contacts_id"])
    code, result = parseResponse(@last_response)
    raise "get contacts failed" unless code == 200 && result[:success].to_s == '1'
    # get contacts metadata successfully
    # perform post contacts card
    Rake::Task["test_func:post_contacts_card"].invoke(cookies, args["contacts_id"])
    code, result = parseResponse(@last_response)
    raise "post contacts card failed" unless code == 200 && result[:success].to_s == '1'
    # post contacts card successfully
    # check contacts card
    case role
    when "admin"

    when "user"

    end
  end

end

# Helper Method

def performPOST(url, data, cookies = {})
  RestClient.post(url, data, :cookies => cookies, :content_type => :json , :accept => :json) { |response, request, result, &block|
    [response.code, JSON.parse(response.body, :symbolize_names => true), response]
  }
end

def performGET(url, data, cookies = {})
  sym_data = data.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  RestClient.get(url, :params => sym_data, :cookies => cookies, :accept => :json) { |response, request, result, &block| 
    [response.code, JSON.parse(response.body, :symbolize_names => true), response]
  }
end

def performPUT(url, data, cookies = {})
  RestClient.put(url, data, :cookies => cookies, :content_type => :json , :accept => :json) { |response, request, result, &block|
    [response.code, JSON.parse(response.body, :symbolize_names => true), response]
  }
end

def performDELETE(url, data, cookies = {})
  sym_data = data.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  RestClient.delete(url, :params => sym_data, :cookies => cookies, :accept => :json) { |response, request, result, &block| 
    [response.code, JSON.parse(response.body, :symbolize_names => true), response]
  }
end

def generateURL(options = {})
  options = { :base_url => 'http://localhost', :port => '8080', :request_uri => '/' }.merge(options)
  options[:base_url] + ':' + options[:port] + options[:request_uri]
end

def parseResponse(response)
  [response.code, JSON.parse(response.body, :symbolize_names => true), response.cookies]
end

def hashEqual?(a, b)
  a.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} == b.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
end

def loginSuccess?(email, password)

end