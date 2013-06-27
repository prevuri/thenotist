require 'spec_helper'

describe BuddiesController do

  describe "GET 'index'" do
    it "renders index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
