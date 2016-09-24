class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  def bike_index_api
    begin
      client = OAuth2::Client.new(Rails.application.secrets.omniauth_provider_key, 
                                     Rails.application.secrets.omniauth_provider_secret,
                                     site: 'https://bikeindex.org/api/v2' )
    
      if session.has_key? :auth_data
        credentials = session[:auth_data]["credentials"]
        credentials.delete("expires") #this boolean is throwing off the OAuth2 parsing
        token = OAuth2::AccessToken.from_hash(client, credentials)
      else
        token = OAuth2::AccessToken.from_hash(client, {})
      end
      token
    rescue Exception => e
      puts "!!!!! FAIL !!!!! #{e.inspect}"
      nil
    end
  end

  private
    

    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Exception => e
        nil
      end
    end

    def user_signed_in?
      return true if current_user
    end

    def correct_user?
      begin 
        @user = User.find(params[:id])
        unless current_user == @user
          redirect_to root_url, :alert => "Access denied."
        end
      rescue ActiveRecord::RecordNotFound  
        redirect_to root_url, :alert => "Bad User ID. Access denied."
      end
    end

    def authenticate_user!
      if !current_user
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
    end

end
