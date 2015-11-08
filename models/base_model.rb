require 'virtus'

class BaseModel
	include Virtus.model

	attribute :id, String
	attribute :content, Array 

	def self.setup_mongodb(client)
		@@client = client
	end

	def find_by_id(id)
		@@client[self.class.name.to_sym].find(:id => id).first     
	end

	def save_all 
		content.each do |entry|
            @@client[self.class.name.to_sym]
                .find(:id => entry["id"])
                .update_one(entry, { :upsert => true })
		end		
	end

	def delete_one(hash)
	    @@client[self.class.name.to_sym]
		    .find(:id => hash["id"])
		    .delete_one
	end
 
	def save_one(hash)
        @@client[self.class.name.to_sym]
	        .find(:id => hash["id"])
	        .update_one(hash, { :upsert => true })
	end

	def load_all
		@content = @@client[self.class.name.to_sym].find({}).to_a
	end

	def load_active
		@content = @@client[self.class.name.to_sym].find({:status => 'active'}).to_a
	end
end