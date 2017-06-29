require 'rails_helper'

RSpec.describe "Outings", type: :request do
  describe "GET /outings" do
    it "works! (now write some real specs)" do
      get outingss_path
      expect(response).to have_http_status(200)
    end
  end
end
