# Enable haml files from the asset pipeline for use with angularjs templates

Rails.application.assets.register_engine '.haml', Tilt::HamlTemplate