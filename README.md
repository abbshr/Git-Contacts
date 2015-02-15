# Git-Contact RESTful API

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
  require "gc-restful-api"

  get '/' do
    content_type 'text/html'
    erb :index
  end

  use App
```