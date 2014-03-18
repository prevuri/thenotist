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
ApplicationSettings.config[:stop_words] = Set.new
File.open(ApplicationSettings.config[:stop_word_file], "r").each_line do |line|
  words = line.split(',')
  words.each { |w| ApplicationSettings.config[:stop_words].add(w) }
end
