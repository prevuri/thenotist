require 'spec_helper'

describe User do

	let(:user) { FactoryGirl.create(:user) }

	subject { user }

	it { should be_valid}

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:notes) }
	it { should respond_to(:user_fb_data) }
	it { should respond_to(:uploaded_files) }
	it { should respond_to(:comments) }
	it { should respond_to(:relationships) }
	it { should respond_to(:buddies) }
	it { should respond_to(:reverse_relationships) }
	it { should respond_to(:followers) }
	it { should respond_to(:following?) }
	it { should respond_to(:follow!) }
	it { should respond_to(:unfollow!) }


	describe "when name is not present" do
    	before { user.name = " " }
    	it { should_not be_valid }
  	end

	describe "when email is not present" do
		before { user.email = " " }
		it { should_not be_valid }
  	end


	describe "when name is too long" do
		before { user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
		addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
			addresses.each do |invalid_address|
				user.email = invalid_address
				user.should_not be_valid
			end
		end
	end
	
	describe "when email format is valid" do
		it "should be valid" do
		  addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
		  addresses.each do |valid_address|
		    user.email = valid_address
		    user.should be_valid
		  end
		end
	end

	describe "following" do
	    let(:other_user) { FactoryGirl.create(:user) }
	    before do
	      user.save
	      user.follow!(other_user)
	    end

	    it { should be_following(other_user) }
	    its(:buddies) { should include(other_user) }

	    describe "followed user" do
	      subject { other_user }
	      its(:followers) { should include(user) }
	    end

	    describe "and unfollowing" do
	      before { user.unfollow!(other_user) }

	      it { should_not be_following(other_user) }
	      its(:buddies) { should_not include(other_user) }
	    end
  	end

end
