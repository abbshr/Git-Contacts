require 'rake'
require 'rest-client'
require 'json'

@last_response = nil # this variable is used to store last response in order to use in later api calls

desc "Test Web Service RESTful APIs"
task :test_all, [:email, :password] do |t, args|
  raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:email, :password]
  puts "test_all"
end


namespace 'test_func' do

  # all functions may vary in future

  desc "post /register api test function"
  task :post_register, [:email, :password] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:email, :password]
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
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:email, :password]
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
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies]
    request_uri = generateURL request_uri: '/logout'
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /logout return #{result} with status #{code}"
  end


  desc "get /contacts/:contacts_id/users api test function"
  task :get_contacts_users, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/users"
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts/:contacts_id/users return #{result} with status #{code}"
  end

  desc "delete /contacts/:contacts_id/user/:user_id api test function"
  task :delete_contacts_user, [:cookies, :contacts_id, :user_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id, :user_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/user/#{args[:user_id]}"
    code, result, @last_response = performDELETE(request_uri, {}, args[:cookies])
    puts "delete /contacts/:contacts_id/user/:user_id return #{result} with status #{code}"
  end

  desc "put /contacts/:contacts_id/user/:user_id/privilege api test function"
  task :put_contacts_user_privilege, [:cookies, :contacts_id, :user_id, :role] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id, :user_id, :role]
    data = {
      "role" => args[:role]
    }
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/user/#{args[:user_id]}/privilege"
    code, result, @last_response = performPUT(request_uri, data.to_json, args[:cookies])
    puts "put /contacts/:contacts_id/user/:user_id/privilege return #{result} with status #{code}"
  end

  desc "get /contacts api test function"
  task :get_contacts, [:cookies] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies]
    request_uri = generateURL request_uri: '/contacts'
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts return #{result} with status #{code}"
  end


  desc "post /contacts api test function"
  task :post_contacts, [:cookies] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies]
    request_uri = generateURL request_uri: '/contacts'
    data = {
      "contacts_name" => "TEST CONTACTS"
    }
    code, result, @last_response = performPOST(request_uri, data.to_json, args[:cookies])
    puts "post /contacts return #{result} with status #{code}"
  end

  desc "get /contacts/:contacts_id/cards api test function"
  task :get_contacts_cards, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/cards"
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts/:contacts_id/cards return #{result} with status #{code}"
  end


  desc "get /contacts/:contacts_id/card/:card_id api test function"
  task :get_contacts_card_by_id, [:cookies, :contacts_id, :card_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id, :card_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/card/#{args[:card_id]}"
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts/:contacts_id/card/:card_id return #{result} with status #{code}"
  end


  desc "post /contacts/:contacts_id/card api test function"
  task :post_contacts_card, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/card"
    data = {
      # to-do
    }
    code, result, @last_response = performPOST(request_uri, data.to_json, args[:cookies])
    puts "post /contacts/:contacts_id/card return #{result} with status #{code}"
  end


  desc "put /contacts/:contacts_id/card/:card_id api test function"
  task :put_contacts_card_by_id, [:cookies, :contacts_id, :card_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id, :card_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/card/#{args[:card_id]}}"
    data = {
      # to-do
    }
    code, result, @last_response = performPUT(request_uri, data.to_json, args[:cookies])
    puts "put /contacts/:contacts_id/card/:card_id return #{result} with status #{code}"
  end


  desc "delete /contacts/:contacts_id/card/:card_id api test function"
  task :delete_contacts_card_by_id, [:cookies, :contacts_id, :card_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id, :card_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/card/#{args[:card_id]}}"
    code, result, @last_response = performDELETE(request_uri, {}, args[:cookies])
    puts "delete /contacts/:contacts_id/card/:card_id return #{result} with status #{code}"
  end


  desc "put /contacts/:contacts_id/metadata api test function"
  task :put_contacts_metadata, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id]
    data = {
      # to-do
    }
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/metadata"
    code, result, @last_response = performPUT(request_uri, data.to_json, args[:cookies])
    puts "put /contacts/:contacts_id/metadata return #{result} with status #{code}"
  end

  desc "get /contacts/:contacts_id/history api test function"
  task :get_contacts_history, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/history"
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts/:contacts_id/history return #{result} with status #{code}"
  end


  desc "post /contacts/:contacts_id/history api test function"
  task :post_contacts_history, [:cookies, :contacts_id, :commit_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id, :commit_id]
    data = {
      "oid" => args[:commit_id]
    }
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/history"
    code, result, @last_response = performPOST(request_uri, data.to_json, args[:cookies])
    puts "post /contacts/:contacts_id/history return #{result} with status #{code}"
  end


  desc "post /contacts/:contacts_id/invitation api test function"
  task :post_contacts_invitation, [:cookies, :contacts_id, :email] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id, :email]
    data = {
      "email" => args[:email]
    }
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/invitation"
    code, result, @last_response = performPOST(request_uri, data.to_json, args[:cookies])
    puts "post /contacts/:contacts_id/invitation return #{result} with status #{code}"
  end

  desc "put /invitation api test function"
  task :put_invitation, [:cookies, :invite_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :invite_id]
    data = {
      "invite_id" => args[:invite_id]
    }
    request_uri = generateURL request_uri: "/invitation"
    code, result, @last_response = performPUT(request_uri, data.to_json, args[:cookies])
    puts "put /invitation return #{result} with status #{code}"
  end

  desc "get /contacts/:contacts_id/requests api test function"
  task :get_contacts_requests, [:cookies, :contacts_id] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id]
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/requests"
    code, result, @last_response = performGET(request_uri, {}, args[:cookies])
    puts "get /contacts/:contacts_id/requests return #{result} with status #{code}"
  end

  desc "put /contacts/:contacts_id/request/:request_id/status api test function"
  task :put_contacts_request_status, [:cookies, :contacts_id, :request_id, :action] do |t, args|
    raise "arguments not enough" unless args.to_hash.keys.map {|k| k.to_sym} == [:cookies, :contacts_id, :request_id, :action]
    data = {
      "action" => args[:action]
    }
    request_uri = generateURL request_uri: "/contacts/#{args[:contacts_id]}/request/#{args[:request_id]}/status"
    code, result, @last_response = performPUT(request_uri, data.to_json, args[:cookies])
    puts "put /contacts/:contacts_id/request/:request_id/status return #{result} with status #{code}"
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
  [response.code, JSON.parse(response.body, :symbolize_names => true)]
end

def hashEqual?(a, b)
  a.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} == b.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
end