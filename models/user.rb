require 'virtus'
require './models/base_model'

class User < BaseModel
	include Virtus.model

	attribute :profile, Array, :default => :fetch_profile

	def fetch_profile
		(find_by_id(id) || {id: id, profile: [])[:profile]
	end

	def modify_profile(tag, selected)        
        profile ||= []
        profile << tag if selected == 'true' 
        profile.uniq! 
        save_one({"id" => id, "profile"=> profile})
	end

	def validate_user
	end
end