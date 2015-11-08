class Login < Sinatra::Application

  get '/users/login' do
    erb :login
  end  

  post '/users/login_process' do
    begin 
      session_id = env["rack.session"]
      raise "user name cannot be empty" if params[:username].empty? 
      uid = params[:username].gsub(/\s+/,"") 
      raise "user name cannot be empty" if uid.empty? 
      Sessions.new.create_session(session_id, uid)
      redirect "/beamer"
    rescue 
      redirect '/users/login'
    end
  end         
end   