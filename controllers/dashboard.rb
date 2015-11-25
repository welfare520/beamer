class ApplicationController < Sinatra::Application

  helpers ApplicationHelpers

  helpers do
    def auth_config
      settings.auth_config
    end
  end

  # use Rack::Auth::Basic, "Restricted Area" do |username, password|
  #   username == auth_config.user and password == auth_config.pass
  # end

  namespace '/dashboard' do
    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Page Not Found']
    end

    get '/bmi' do
      beamers = Beamer.new.load_all 
      erb :template, :layout => :bmi, :locals => {
                                                  :beamhash => beamhash,
                                                  :beamers => beamers 
                                                }
    end

    get '/beamer/:id' do
      hash = Beamer.new.find_by_id(params[:id]) 
      halt 200, hash.to_json 
    end

    post '/beamer/:id/update' do
      begin 
        id = params[:id]
        tag = params[:tag]
        name = params[:name]

        beamer = Beamer.new({id: id, tag: tag, name: name})
        beamer.update_beamer 
        halt 201, "saved"
      rescue Exception => e
        halt 400, e.message 
      end
    end

    post '/beamer/:id/add' do
      begin 
        id = params[:id]
        tag = params[:tag]
        name = params[:name]

        beamer = Beamer.new({id: id, tag: tag, name: name})
        beamer.update_beamer 
        halt 201, "saved"
      rescue Exception => e
        halt 400, e.message 
      end
    end

    delete '/beamer/:id/delete' do
      begin 
        beamer = Beamer.new({id: params[:id]})
        beamer.delete_beamer   
        halt 201, "deleted"
      rescue Exception => e
        halt 400, e.message 
      end
    end

    post '/beamer/upload/:id/icon' do
      file_ext = File.extname(params[:data][:filename])  
      filename = params[:id] + file_ext
      File.open('./public/upload/icon/' + filename, "w") do |f|
        f.write(params[:data][:tempfile].read)
      end
      halt 201, "file uploaded"  
    end


  end

end
