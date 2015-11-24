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
      erb :template, :locals => {:beamhash => beamhash}, :layout => :bmi
    end
  end

end
