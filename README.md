# Gitdb

**Git-Contacts** backend data engine  
a simple data storage based on git, designed for Git-Contacts

## Installation

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

##### instance: `Gitdb::Contacts.new(uid)`

+ property: `repo`
+ method: `exist?(gid)`
+ method: `create(gid)`
+ method: `access(gid)`
+ method: `getmeta`
+ method: `setmeta(Hash)`
+ method: `get_all_cards`
+ method: `get_card_by_id(id)`
+ method: `read_change_history`
+ method: `revert_to(sha, authorhash, message)`
+ method: `make_a_commit(optionhash)`

#### Class: `Gitdb::Card`

+ class method: `exist?(repo, id)`

##### instance: `Gitdb::Card.new(repo)`

+ method: `create(uid)`
+ method: `access(id)`
+ method: `format_card(id, uid)`
+ method: `getdata`
+ method: `setdata(Hash)`
+ method: `getmeta`
+ method: `setmeta(Hash)`
+ method: `delete`
+ method: `add_to_stage(id, content)`
