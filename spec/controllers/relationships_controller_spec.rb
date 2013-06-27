require 'spec_helper'

describe RelationshipsController do
	let(:user) { FactoryGirl.create(:user) }
  	let(:buddy) { FactoryGirl.create(:user) }

	before { sign_in user }

  	describe "creating a relationship" do

		it "should increment the Relationship count" do
		  	expect do
	    		post :create, relationship: { buddy_id: buddy.id }
			end.to change(Relationship, :count).by(1)
		end

		it "should respond with success" do
		   	post :create, relationship: { buddy_id: buddy.id }
	  		response.should be_success
		end
	end


	describe "destroying a relationship" do

		before { user.follow!(buddy) }
		let(:relationship) { user.relationships.find_by_buddy_id(buddy.id) }

		it "should decrement the Relationship count" do
			expect do
				delete :destroy, :id => relationship.id
		  	end.to change(Relationship, :count).by(-1)
		end

		it "should respond with success" do
			delete :destroy, :id => relationship.id
		  	response.should be_success
		end
	end

end
