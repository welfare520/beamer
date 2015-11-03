module ApplicationHelpers

  def authenticate! 
    session_id = env["rack.session"]["session_id"]    
      unless Sessions.new.session_valid?(session_id, params[:uid])  
        redirect '/users/login'
      end   
    end

  def run_with_error_handling
    begin
      puts env['rack.session.authentication'] 
      unless env['rack.session.authentication'] 
        raise Exceptions::SessionNotExist, "session not found"
      end
      yield 
    rescue Exceptions::SessionNotExist => e 
      redirect '/users/login'
    rescue 
      halt 400, "Bad request"
    end    
  end

end
