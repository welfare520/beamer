require 'sinatra'

class Authentication < Sinatra::Application

  def initialize(app)
    @app = app       
  end                

  def call(env)     	
    session_id = env["rack.session"]
    request = Rack::Request.new(env)    
    if Sessions.new.session_valid?(session_id)
    	env['rack.session.uid'] = Sessions.new.find_by_id(session_id)['user']
    	env['rack.session.authentication'] = true 
    end
    @app.call(env)
  end             
end   