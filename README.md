# Gc::Restful::Api

A Rack middleware of RESTful API for Git-Contacts.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gc-restful-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gc-restful-api

## Usage

```ruby
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
```