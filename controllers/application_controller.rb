require 'sinatra'
require 'omniauth'
require 'omniauth-google-oauth2'

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

  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :google_oauth2, "591662158863-mjrqke4fl522f70sr6252spgp12olvvk.apps.googleusercontent.com", "DIo6BOVfQvNLrefRu4iN2Xd6", 
      {:scope => 'https://www.googleapis.com/auth/gmail.compose', :name => 'google'}
  end

  helpers ApplicationHelpers

  helpers do
    def auth_config
      settings.auth_config
    end
  end

  get '/test' do
    redirect '/auth/google'
  end

  post '/auth/google/callback' do
    "request.env.inspect"  
  end

  get '/users/logout' do
    run_with_error_handling { |uid|
      Sessions.new.delete_session(uid)
      redirect '/users/login'
    }
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
        run_with_error_handling { |uid|
          user = User.new(:id => uid)
          user.fetch_profile
          user_show_beamer = beamhash.delete_if {|key, value| user.profile.include?(key)}
          user_selected_beamer = beamhash.keep_if {|key, value| user.profile.include?(key)}
          user_defined_beamer = user.profile - beamhash.keys 
          erb :beamer, :locals => {:name => uid, 
                                   :showbeamer => user_show_beamer, 
                                   :userbeamer => user_selected_beamer,
                                   :definebeamer => user_defined_beamer}
        }      
      end 

      post '/update/add/:tid' do
        run_with_error_handling { |uid|
          user = User.new(:id => uid)
          user.fetch_profile
          user.modify_profile(params[:tid], true)  
          halt 201, {'status' => 'tag added'}.to_json 
        }
      end

      post '/update/delete/:tid' do
        run_with_error_handling { |uid|
          user = User.new(:id => uid)
          user.fetch_profile
          user.modify_profile(params[:tid], false) 
          halt 201, {'status' => 'tag deleted'}.to_json 
        }
      end

      post '/update/user/defined/comment' do
        run_with_error_handling { |uid|
          user = User.new(:id => uid)
          user.fetch_profile

          dir = Dir.mktmpdir
          begin
            File.open(dir +'/comment.txt', 'w') { |file| file.write(params[:comment]) }
            output = `Rscript rscript/beamer-analysis.R #{dir}/comment.txt`
            (output.split(" ").drop(1)).each do |tag|
              user.modify_profile(tag.gsub!(/\A"|"\Z/, ''), true) 
            end
          ensure
            FileUtils.remove_entry_secure dir
          end  
          halt 201, {'status' => 'comment added'}.to_json 
        }
      end
    end
  end

  def beamhash
    {
      "bomb" => "Bomb",
      "bowling" => "Bowling",
      "car" => "Car",
      "cup" => "Cup",
      "weight" => "Weight",
      "football" => "Football",
      "business" => "Business",
      "rocket" => "Rocket",
      "sport" => "Sport",
      "shopping" => "Shopping",
      "trash" => "Trash"
    }    
  end
end

require_relative 'dashboard'
