# singleton
module ApplicationSettings
  def config
    @@config ||= {}
  end
  def config= hash
    @@config = hash.inject({}) { |mem, (k,v)| mem[k.to_sym] = v; mem }  # symbolize keys
  end
  module_function :config=, :config
end

# load environment-specific settings
ApplicationSettings.config = YAML.load_file("config/application_settings.yml")[Rails.env]
