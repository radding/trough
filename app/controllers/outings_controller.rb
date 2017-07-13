class OutingsController < ApplicationController
  include ActionController::Serialization
  before_action :set_outing, only: [:show, :update, :destroy]
  before_action :ensure_team, only: [:create, :index]
  before_action :authenticate_user!

  # GET /teams/1/outings
  def index
    if (request.query_parameters["exclude_me"].present?)
      @outings = @team.outings.excludes current_user
    else
      @outings = @team.outings
    end
    render json: @outings#, root: false
  end

  # GET /teams/1/outings/1
  def show
    render json: @outing
  end

  # POST /teams/1/outings
  def create
    # ActiveRecord::Base.transaction do
    #   place = Place.find_or_create_by(outing_params[:place][:name])
    #   outing_params[:place].delete
    #   outing_params[:place_id] = place.id
    #   @outing = Outing.new(outing_params)
    # end
    if @team.nil?
      render status: :unprocessable_entity
    end
    place = Place.find_or_create_by(name: outing_params[:place][:name], google_place: outing_params[:place][:google_place])
    test_hash = outing_params
    test_hash.delete(:creator)
    test_hash[:place] = place
    test_hash[:team_id] = @team.id
    test_hash[:user_id] = outing_params[:creator][:id]
    
    @outing = Outing.new(test_hash)

    if @outing.save
      render json: @outing, status: :created
    else
      render json: @outing.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1/outings/1
  def update
    if @outing.update(outing_params)
      render json: @outing
    else
      render json: @outing.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1/outings/1
  def destroy
    @outing.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_outing
      @outing = Outing.find(params[:id])
    end

    def ensure_team
      @team = Team.find(params[:team_id])
    end

    # Only allow a trusted parameter "white list" through.
    def outing_params
      params.require(:outing).permit(
        :name, 
        :departure_time,
        creator: [:id],
        place: [
          :google_place,
          :name
        ])
    end

    def default_serializer_options
      {
        root: false
      }
    end
end
