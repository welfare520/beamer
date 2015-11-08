module ApplicationHelpers

  def authenticate! 
    session_id = env["rack.session"]["session_id"]    
    unless Sessions.new.session_valid?(session_id, params[:uid])  
      redirect '/users/login'
    end   
  end

  def run_with_error_handling
    begin
      unless env['rack.session.authentication'] 
        raise Exceptions::SessionNotExist, "session not found"
      end
      yield(env['rack.session.uid']) if block_given?
    rescue Exceptions::SessionNotExist => e 
      redirect '/users/login'
    rescue Exceptions => e
      halt 400, {"status" => e.message}.to_json 
    end    
  end

end
