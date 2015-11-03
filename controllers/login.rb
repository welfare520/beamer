class Login < Sinatra::Application
  get '/users/login' do
    erb :login
  end  

  post '/users/login_process' do
    begin 
      session_id = env["HTTP_COOKIE"].gsub("rack.session=","") 
      raise "user name cannot be empty" if params[:username].empty? 
      uid = params[:username].gsub(/\s+/,"")
      Sessions.new.create_session(session_id, uid)
      redirect "/beamer?uid=#{uid}"
    rescue 
      redirect '/users/login'
    end
  end            
end   