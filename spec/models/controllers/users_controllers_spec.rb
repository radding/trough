require "rails_helper"

RSpec.describe UsersController, :type => :controller do
    describe "POST /auth/" do
    	#Create a user
    	it "creates user" do

    		#Find a user

    	end

    	it "creates user improperly" do

    	end
    end

	#Sign_in
	describe "POST /auth/sign_in" do
		it "tests valid sign_in" do

		end
		it "tests invalid sign_in" do

		end
	end

    #validate_token
    it "tests stays signed_in" do

    end

    #Sign_out
    it "signs out user" do

    end

    #Edit a user
	describe "PUT /auth/" do
		it "tests valid password change" do

		end
		it "tests invalid password change" do

		end
	end

    #Delete a user
    describe "DELETE /auth/" do
    	it "deletes user" do

    	end

    	it "deletes non-existent user" do

    	end
    end
end