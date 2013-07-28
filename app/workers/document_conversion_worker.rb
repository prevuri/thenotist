class DocumentConversionWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false
  
  def perform file_name

  end
end