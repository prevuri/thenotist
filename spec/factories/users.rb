
#Factory user definition
FactoryGirl.define do
	factory :user do
		name 'Testy Tasticles'
		email 'testy@example.com'
		password 'changeme'
		password_confirmation 'changeme'
		#confirmed_at Time.now	
	end
end