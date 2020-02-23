class DistancesController < ApplicationController
  def new
    @places = Place.all
    if @places.empty?
      flash[:notice] = "Place not created"
      redirect_to new_place_path
    else
      @from = Place.first
      @to = Place.first
      flash.now[:success] = "The distance between <b>#{@from.title}</b> and <b>#{@to.title}</b> is #{@from.distance_from(@to.to_coordinates)} km"
      @distance = []
      @distance << @from
      @distance << @to
      @hash = Gmaps4rails.build_markers(@distance) do |place, marker|
        marker.lat place.latitude
        marker.lng place.longitude
        marker.infowindow render_to_string(:partial => "/places/info", :locals => {:place => place})
        marker.title place.title
        marker.json({:id => place.id})
      end
    end
  end

  def create
    @places = Place.all
    @from = Place.find_by(id: params[:from])
    @to = Place.find_by(id: params[:to])
    if @from && @to
      flash.now[:success] = "The distance between <b>#{@from.title}</b> and <b>#{@to.title}</b> is #{@from.distance_from(@to.to_coordinates)} km"
      @distance = []
      @distance << @from
      @distance << @to
      @hash = Gmaps4rails.build_markers(@distance) do |place, marker|
        marker.lat place.latitude
        marker.lng place.longitude
        marker.infowindow render_to_string(:partial => "/places/info", :locals => {:place => place})
        marker.title place.title
        marker.json({:id => place.id})
      end
      render 'new'
    else
      flash[:notice] = "Place not created"
      redirect_to new_place_path
    end
  end
end
