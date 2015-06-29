# Gitdb

[![Gem Version](https://badge.fury.io/rb/gitdb.svg)](http://badge.fury.io/rb/gitdb)

**Git-Contacts** backend data engine  
a simple data storage based on git, designed for Git-Contacts

## Installation

**CMake is required!**

Add this line to your application's Gemfile:

```ruby
gem 'gitdb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitdb

## Usage

#### Module: `Gitdb`

+ constant: `Gitdb::STORAGE_PATH`
+ class method: `setup_storage`

#### Class: `Gitdb::Contacts`

+ class method: `exist?(gid)`

##### instance: `Gitdb::Contacts.new(user_id)`

+ property: `repo`
+ method: `exist?(contacts_id)`
+ method: `create(contacts_name)`
+ method: `access(contacts_id)`
+ method: `getmeta`
+ method: `setmeta(Hash)`
+ method: `get_cards { |card| }`
+ method: `get_all_cards`
+ method: `get_card_by_id(card_id)`
+ method: `read_change_history { |commit| }`
+ method: `revert_to(sha, {})`
+ method: `make_a_commit({})`

#### Class: `Gitdb::Card`

+ class method: `exist?(repo, id)`

##### instance: `Gitdb::Card.new(repo)`

+ method: `create(user_id)`
+ method: `access(card_id)`
+ method: `format_card(id, uid)`
+ method: `getdata`
+ method: `setdata(Hash)`
+ method: `getmeta`
+ method: `setmeta(Hash)`
+ method: `delete`
+ method: `add_to_stage(id, content)`
