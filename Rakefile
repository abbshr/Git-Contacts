require 'rake'
require 'rest-client'
require 'json'

@cookies = nil
@response = nil

desc "Test Web Service RESTful APIs"
task :test_all do
  puts "test_all"
end


desc "Test POST /register API"
task :test_register do
  loop do
    request_uri = generateURL request_uri: '/register'
    data = {
      "email" => "test"+rand(100000).to_s,
      "password" => "1q2w3e4r5t"
    }
    code, result = performPOST(request_uri, data.to_json)
    if code == 200 && result[:success].to_s == '1'
      puts "post /register API test passed."
    elsif code != 409
      puts request[:errmsg]
      puts "post /register API test failed."
    end
    break if code != 409
  end
end


desc "Test POST /login API"
task :test_login do
  request_uri = generateURL request_uri: '/login'
  data = {
    "email" => "test",
    "password" => "testuser"
  }
  code, result, response = performPOST(request_uri, data.to_json)
  if code == 200 && result[:success].to_s == '1'
    puts "post /login API test passed."
    @cookies = response.cookies
  else
    puts result[:errmsg]
    puts "post /login API test failed."
  end
end


desc "Test GET /logout API"
task :test_logout => [:test_login] do
  request_uri = generateURL request_uri: '/logout'
  code, result = performGET(request_uri, {}, @cookies)
  if code == 200 && result[:success].to_s == '1'
    puts "get /logout API test passed."
  else
    puts result[:errmsg]
    puts "get /logout API test failed."
  end
end


desc "Test GET /contacts API"
task :test_get_contacts => [:test_login] do
  request_uri = generateURL request_uri: '/contacts'
  code, result = performGET(request_uri, {}, @cookies)
  if code == 200 && result[:success].to_s == '1'
    puts "get /contacts API test passed."
  else
    puts result[:errmsg]
    puts "get /contacts API test failed."
  end
end


desc "Test POST /contacts API"
task :test_post_contacts => [:test_login] do
  request_uri = generateURL request_uri: '/contacts'
  data = {
    "contacts_name" => "TEST CONTACTS"
  }
  code, result, @response = performPOST(request_uri, data.to_json, @cookies)
  if code == 200 && result[:success].to_s == '1'
    puts result[:contacts_id]
    puts "post /contacts API test passed."
  else
    puts result[:errmsg]
    puts "post /contacts API test failed."
  end
end

desc "Test GET /contacts/:contacts_id/cards API"
task :test_get_contacts_cards => [:test_post_contacts] do
  last_result = JSON.parse(@response.body, :symbolize_names => true)
  request_uri = generateURL request_uri: "/contacts/#{last_result[:contacts_id]}/cards"
  code, result, @response = performGET(request_uri, data.to_json)
  if code == 200 && result[:success].to_s == '1'
    #puts result[:cards]
    puts "get /contacts/:contacts_id/cards API test passed."
  else
    puts result[:errmsg]
    puts "get /contacts/:contacts_id/cards test failed."
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

def generateURL(options = {})
  options = { :base_url => 'http://localhost', :port => '8080', :request_uri => '/' }.merge(options)
  options[:base_url] + ':' + options[:port] + options[:request_uri]
end