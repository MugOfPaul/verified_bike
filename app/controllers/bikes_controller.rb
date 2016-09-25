require 'open-uri'

class BikesController < ApplicationController
  before_action :set_bike_by_uid, only: [:show, :edit, :update ]

  def unverified
  end

  def image
    @bike = Bike.find_by_id(params[:id])
    @api        = bike_index_api
    @bike_data  = JSON.parse(@api.get("bikes/#{@bike.bike_index_uid}").body)

    img   = MiniMagick::Image.open(@bike_data["bike"]["public_images"][0]["medium"])
  
    img = img.composite(logo_image) do |c|
       c.compose "Over"
       c.geometry "+10+10"
    end
    send_data img.to_blob, :disposition => 'attachment', :filename=>"verified_bike_#{@bike.id}.jpg" 
  end

  # GET /bikes
  # GET /bikes.json
  def index
    @bikes = Bike.all
  end

  # GET /bikes/1
  # GET /bikes/1.json
  def show
    @bike = Bike.find_by_id(params[:id])
    if !@bike.nil?
      @api        = bike_index_api
      @bike_data  = JSON.parse(@api.get("bikes/#{@bike.bike_index_uid}").body)
    else
      redirect_to(:bikes_unverfied, warning: "Bike not found.")
    end
  end

  # GET /bikes/new
  def new
    @bike       = Bike.new(params.permit(:bike_index_uid, :user_id))
    @api        = bike_index_api
    @bike_data  = JSON.parse(@api.get("bikes/#{@bike.bike_index_uid}").body)
  end

  # GET /bikes/1/edit
  def edit
  end

  # POST /bikes
  # POST /bikes.json
  def create
    @bike = Bike.new(params.permit(:bike_index_uid, :user_id))

    respond_to do |format|
      if @bike.save
        format.html { redirect_to @bike, notice: 'Your bike is now verified!' }
        format.json { render :show, status: :created, location: @bike }
      else
        format.html { render :new }
        format.json { render json: @bike.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bikes/1
  # PATCH/PUT /bikes/1.json
  def update
    respond_to do |format|
      if @bike.update(bike_params)
        format.html { redirect_to @bike, notice: 'Bike was successfully updated.' }
        format.json { render :show, status: :ok, location: @bike }
      else
        format.html { render :edit }
        format.json { render json: @bike.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bikes/1
  # DELETE /bikes/1.json
  def destroy
    @bike = Bike.find(params[:id])
    @bike.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Bike is no longer verified.' }
      format.json { head :no_content }
    end
  end

  private

    def logo_image 
      path = "#{request.protocol}#{request.host_with_port}#{ActionController::Base.helpers.asset_path('VB_Watermark.png')}"
      puts "Logo Image: #{path}"
      @logo_image ||= MiniMagick::Image.open(path)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_bike_by_uid
      @bike = Bike.find_by( bike_index_uid: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bike_params
      params.require(:bike).permit(:bike_index_uid, :user_id)
    end
end
