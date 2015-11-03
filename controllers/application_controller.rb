class ApplicationController < Sinatra::Application

  set :root, File.join(File.dirname(__FILE__), '..')
  set :public_folder, File.dirname(__FILE__) + '/../public' 
  set :views, File.expand_path('../../views', __FILE__)
  set :auth_config, AuthConfig.new
  set :environment, :production
  enable :static
  enable :sessions
  set :sessions, :expire_after => 2592000

  configure do
    Dir.mkdir('logs') unless File.exist?('logs')
    file = File.new("logs/common.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
  end  

  helpers ApplicationHelpers

  helpers do
    def auth_config
      settings.auth_config
    end
  end

  # use Rack::Auth::Basic, "Restricted Area" do |username, password|
  #   username == auth_config.user and password == auth_config.pass
  # end

  namespace '/' do
    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Page Not Found']
    end

    get do
      redirect '/beamer'
    end

    namespace 'beamer' do
      get do
        run_with_error_handling {
          erb :beamer
        }      
      end 
    end
  end
end

