class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
    before_action :set_team
    before_action :ensure_team, only: [:create]

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
      if !User.exsists?(email: user_params[:email])
        resp = {:error => "user_not_found", :status => "404", :message => "User with email #{user_params[:email]} not found"}
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
        params.require(:user).permit(:name, :email)
      end
end
