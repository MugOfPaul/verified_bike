class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, :except => [:index]

  # def index
  #   @users = User.all
  # end

  def show
    @user                 = User.find(params[:id])
    @bike_ids             = session[:auth_data]["info"]["bike_ids"]
    @bikes                = Hash.new
    @api                  = bike_index_api

    @bike_ids.each do |bike_id|
        response  = @api.get("bikes/#{bike_id}")
        @bikes[bike_id] = JSON.parse(response.body)
    end
   
  end

end
