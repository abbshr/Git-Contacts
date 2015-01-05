require "rugged"
require "Card"

class Contacts

	def initialize uid
		@uid = uid
	end

	private
	def gen_hash
		# TODO: 32bit code
		rand.to_s
	end

	def self::exist? gid
		Dir::exist? gid
	end

	def exist? gid
		Contacts::exist? gid
	end

	def create name
		# generate a unique hash code
		while exist? @gid = gen_hash end
		# create & open repository
		@repo = Rugged::Repository.init_at @gid
		# setup meta data
		setmeta :name => name, :gid => @gid, :uid => @uid
	end

	def access gid
		@repo = Rugged::Repository.new gid
	end

	def get_all_cards
		@repo.head.target.tree.collect.each { |o| o[:name] }
	end

	def self::get_cards_by gid, function
		
	end

	def get_card_by_id id
		@repo.head.target.tree.find do |o| 
			Card.new if o[:name] == id
		end
	end

	def getmeta
		@meta = {
			:name => @repo.config['repo.name'],
			:uid => @repo.config['repo.owner'],
			:gid => @repo.config['repo.gid']
		}
	end

	def setmeta hash
		@repo.config['repo.name'] = hash[:name] if hash.member? :name
		@repo.config['repo.owner'] = hash[:owner] if hash.member? :owner
		@repo.config['repo.gid'] = hash[:gid] if hash.member? :gid
	end

	def read_change_history
		walker = Rugged::Walker.new repo
		walker.push repo.head.target_id
		walker.collect.each { |c| c }
	end

	def revert_to sha
		
	end

end