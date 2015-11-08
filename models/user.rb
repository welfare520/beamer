require 'virtus'
require './models/base_model'

class User < BaseModel
	include Virtus.model

	attribute :profile, Array, :default => :fetch_profile
	attribute :id, String 

	def fetch_profile
	  @profile = (find_by_id(id) || {id: id, profile: []})[:profile]
	end

	def modify_profile(tag, append = false)        
    @profile ||= []
    if append 
    	@profile << tag 
    else
    	@profile.delete(tag)
    end
    @profile.uniq! 
    save_one({"id" => id, "profile"=> @profile})
	end

	def validate_user
	end
end