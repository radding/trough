class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
    def index
        render json: {:version => "0.0.1", :status => "ok", :code => "200"}
    end
end
