require 'sinatra'

class Authentication < Sinatra::Application

  def initialize(app)
    @app = app       
  end                

  def call(env)     	
    session_id = env["HTTP_COOKIE"].gsub("rack.session=","")   
    request = Rack::Request.new(env)
    env['rack.session.authentication'] = Sessions.new.session_valid?(session_id, request.params['uid']) ? true : false
    @app.call(env)
  end             
end   