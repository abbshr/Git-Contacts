require "erb"
require 'sinatra'
require "sinatra/config_file"
require "gc-restful-api"

register Sinatra::ConfigFile

# load configration
config_file "config.yml"

get '/' do
  content_type 'text/html'
  erb :index, :locals => { :session => session[:uid] }
end

get '/inspect' do
  content_type 'text/html'
  erb :inspect
end

use App
