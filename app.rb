require "erb"
require 'sinatra'
require "sinatra/config_file"
require "gc-restful-api"

register Sinatra::ConfigFile

# load configration
config_file "config.yml"

get '/' do
  content_type 'text/html'
  erb :index
end

use App
