require 'spec_helper'

describe Relationship do

  let(:follower) { FactoryGirl.create(:user) }
  let(:buddy) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(buddy_id: buddy.id) }

  subject { relationship }  

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to follower_id" do
      expect do
        Relationship.new(follower_id: follower.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "follower methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:buddy) }
    its(:follower) { should == follower }
    its(:buddy) { should == buddy }
  end

  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end

  describe "when buddy id is not present" do
    before { relationship.buddy_id = nil }
    it { should_not be_valid }
  end
end