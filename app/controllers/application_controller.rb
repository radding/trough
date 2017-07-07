class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  #include ActionController::Serialization
    def index
        render json: {:version => "0.0.1", :status => "ok", :code => "200"}
    end
end
