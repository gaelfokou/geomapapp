class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update]

  def index
    @places = Place.order('created_at DESC')
    @hash = Gmaps4rails.build_markers(@places) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
      marker.infowindow render_to_string(:partial => "/places/info", :locals => {:place => place})
      marker.title place.title
      marker.json({:id => place.id})
    end
  end

  def show
  end

  def new
    @place = Place.new
  end

  def edit
  end

  def create
    @place = Place.new(place_params)
    if @place.save
      redirect_to root_path
    else
      flash.now[:notice] = "Location not selected"
      render 'new'
    end
  end

  def update
    if @place.update(place_params)
      redirect_to root_path
    else
      flash.now[:notice] = "Location not selected"
      render 'edit'
    end
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(:title, :raw_address, :latitude, :longitude, :visited_by)
  end
end
