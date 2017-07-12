class UsersController < ApplicationController
    include ActionController::Serialization
    before_action :set_user, only: [:show, :update, :destroy]
    before_action :set_team
    before_action :ensure_team, only: [:create]
    before_action :authenticate_user!

    # GET /teams/1/users or /users
    def index
      render json: (@team.nil? ? User.all : @team.users)
    end

    # GET /teams/1/users/1 or /users/1
    def show
      render json: (@team.nil? ? @user : @team.users.find(params[:id]))
    end

    # POST /teams/1/users or /users
    def create
      if !User.exists?(id: user_params[:id])
        resp = {:error => "user_not_found", :status => "404", :message => "User with id #{user_params[:email]} not found"}
        render json: resp, :status => :notfound and return 
      end
      @user = User.find(user_params[:id])
      @team.users << @user
      render json: @user
    end

    # PATCH/PUT /teams/1
    def update
      if @team.nil?
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      else
        if !@team.users.where(id: @user.id).any?
          @team.users << @user
          render json: @user
        else
          render json: {:error => "user_in_team", :status=>409, :message => "User is already in team"}, :status => :conflict
        end
        
      end
    end

    # DELETE /teams/1
    def destroy
      if @team.nil?
        @user.destroy
        return
      end
      @team.users.delete(@user)
    end

    def me
        render json: current_user
    end
    
    # POST /teams/1/outings/1/users
    def join
      user = User.find(user_params[:id])
      outing = Outing.find(params[:outing_id])
      outing.users << user
      render json: outing
    end

    private
      def set_team
        @team = params[:team_id].present? ? Team.find(params[:team_id]) : nil
      end

      def set_user
        @user = User.find(params[:id])
      end

      def ensure_team
        @team = Team.find(params[:team_id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :id)
      end

      def default_serializer_options
      {
        root: false
      }
      end
end
