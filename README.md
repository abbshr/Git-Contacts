### usage

```sh
  # install dependiences
  bundler
```

```sh
  # start as a stand-alone web service
  ruby api.rb
```

or used as a rack middleware:

```ruby
  require 'sinatra'
  require_relative './api'

  use Rack::Lint
  use GCApp

  get '/hello' do 
    'World'
  end
```