require 'sinatra'
require 'sinatra/base'
require "sinatra/cookies"
require "sinatra/config_file"
require "rack/session/moneta"
require 'redis-sinatra'
require 'json'
#require 'redis'
require 'gitcontacts'

class App < Sinatra::Base
  register Sinatra::ConfigFile

  # load configration
  config_file "config.yml"

  # before each request
  before do
    # for dev test
    session[:uid] = 'qwer'
    content_type 'application/json'
  end

  class Hash
    def to_json
      JSON.generate self
    end
  end

  # for dev test
  get '/' do
    puts session[:uid]
    {:name => 'Ran'}.to_json
  end

  # routes
  require_relative 'routes/contacts'
  require_relative 'routes/card'
  require_relative 'routes/user'
  require_relative 'routes/request'
  require_relative 'routes/invitation'

  not_found do
    { :errmsg => "NOT FOUND! may be this api hasn't been public now." }.to_json
  end
end
