class ActivityPresenter < SimpleDelegator
	attr_reader :activity

	def initialize(activity, view)
		super(view)
		@activity = activity
	end

	def render_activity
		div_for activity do
			if activity.user == current_user
				"You " + render_partial + render_time_partial + render_subsection_partial
			else
				link_to(activity.user.name.split[0], profile_path(activity.user), class: 'user-name') + " " + render_partial + render_time_partial + render_subsection_partial
			end

		end
	end

	def render_partial
		locals = {
			activity: activity,
			presenter: self
		}
		locals[activity.trackable_type.underscore.to_sym] = activity.trackable
		render partial_path, locals
	end

	def render_subsection_partial
		locals = {
			activity: activity,
			presenter: self
		}
		locals[activity.trackable_type.underscore.to_sym] = activity.trackable
		render partial_subsection_path, locals
	end

	def render_time_partial
		locals = {
			activity: activity,
			presenter: self
		}
		locals[activity.trackable_type.underscore.to_sym] = activity.trackable
		render partial_time_path, locals
	end

	def partial_time_path
		"main/time"
	end
	def partial_path
		partial_paths.detect do |path|
    		lookup_context.template_exists? path, nil, true
  		end || raise("No partial found for activity in #{partial_paths}")
	end

	def partial_subsection_path
		partial_subsection_paths.detect do |path|
			lookup_context.template_exists? path, nil, true
		end || raise("No partial found for activity in #{partial_subsection_paths}")
	end

	def partial_paths
		[
			"main/#{activity.trackable_type.underscore}/#{activity.action}",
			"main/#{activity.trackable_type.underscore}",
			"main/activity"
		]
	end

	def partial_subsection_paths
		[
			"main/#{activity.trackable_type.underscore}/subsection",
			"main/#{activity.trackable_type.underscore}",
			"main/activity"
		]
	end
end
