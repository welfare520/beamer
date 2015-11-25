require 'virtus'
require './models/base_model'

class Beamer < BaseModel
	include Virtus.model

	attribute :tag, String
	attribute :id, String 
	attribute :name, String 

	def update_beamer 
		save_one({"id" => id, "tag"=> tag, "name" => name})
	end

	def delete_beamer 
		delete_one({"id" => id})
	end
end