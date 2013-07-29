class DocumentConversionWorker
  require 'RMagick'
  include Magick
  include Sidekiq::Worker
  sidekiq_options :retry => false

  # passing in a path
  def perform params
    current_user = User.find(params["current_user_id"])
    note = current_user.notes.find(params["note_id"])
    local_pdf_file = params["local_pdf_file"]

    # PDF -> PNG
    converted_pages = RGhost::Convert.new(local_pdf_file).to :png, :resolution => 144, :multipage => true

    # local -> S3 (AWS creds should be initialized already)
    # and create models
    bucket = AWS::S3.new.buckets['thenotist']
    images = []
    converted_pages.each_with_index do |path, i|
      obj = bucket.objects["image_store/#{SecureRandom.uuid}.png"]
      obj.write(Pathname.new(path), :acl => :public_read)

      # get thumbnail
      obj_thmb = bucket.objects["image_store/#{SecureRandom.uuid}-thumbnail.png"]
      thumb = ImageList.new(path)
      thumb = thumb.scale(80*3, 110*3)
      thumb_path = String.new(path)
      thumb_path.insert(-5, '-thumbnail')
      thumb.write(thumb_path)
      obj_thmb.write(Pathname.new(thumb_path), :acl => :public_read)

      images << note.uploaded_files.build(:public_path => obj.public_url.to_s, :page_number => i, :thumb_url => obj_thmb.public_url.to_s)
    end

    # delete the PDF file and other files
    File.delete(local_pdf_file)
    converted_pages.each { |p| File.delete(p) }

    note.save!
    images.each do |img|
      img.save!
    end
    track_activity note
  end
end