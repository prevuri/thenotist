class DocumentConversionWorker
  require 'RMagick'
  # require 'Nokogiri'
  include Magick
  include Sidekiq::Worker
  sidekiq_options :retry => false

  # passing in a path
  def perform params
    current_user = User.find(params["current_user_id"])
    note = current_user.notes.find(params["note_id"])
    local_pdf_file = params["local_pdf_file"]

    begin

      #PDF -> HTML
      Kristin.convert(local_pdf_file, 'document.htm', {hdpi: 144, vdpi: 144, fit_width: 920})

      converted_doc = Nokogiri::HTML(open("document.htm"))  

      converted_doc.css(".t, .bi").each do |line|
        line['data-guid'] = SecureRandom.hex
      end

      converted_css = converted_doc.css("style")
      converted_pages = converted_doc.css(".pd")


      #insert_guid

      bucket = AWS::S3.new.buckets['thenotist']

      converted_css.each_with_index do |css, i|
        if i == 1
          next
        end

        stylesheet = File.new("#{i}.css", "w")
        stylesheet.write(css)
        stylesheet.close

        style_path = Pathname.new(stylesheet)

        obj = bucket.objects["css_store/#{SecureRandom.uuid}.css"]        
        obj.write(style_path, :acl => :public_read)

        note.uploaded_css_files.create(:public_path => obj.public_url.to_s)
        File.delete(stylesheet)
      end

      converted_pages.each_with_index do |string, i|
        page = File.new("#{i}.htm", "w")
        page.write(string.to_html)
        page.close

        page_path = Pathname.new(page)

        obj = bucket.objects["page_store/#{SecureRandom.uuid}.htm"]        
        obj.write(page_path, :acl => :public_read)


        note.uploaded_files.create(:public_path => obj.public_url.to_s, :page_number => i, :thumb_url => obj.public_url.to_s)
        File.delete(page)
      end


      # # PDF -> PNG
      # converted_pages = RGhost::Convert.new(local_pdf_file).to :png, :resolution => 144, :multipage => true

      # # local -> S3 (AWS creds should be initialized already)
      # # and create models
      # bucket = AWS::S3.new.buckets['thenotist']
      # images = []
      # converted_pages.each_with_index do |path, i|
      #   obj = bucket.objects["image_store/#{SecureRandom.uuid}.png"]
      #   obj.write(Pathname.new(path), :acl => :public_read)

        # get thumbnail
      #   obj_thmb = bucket.objects["image_store/#{SecureRandom.uuid}-thumbnail.png"]
      #   thumb = ImageList.new(path)
      #   thumb = thumb.scale(80*3, 110*3)
      #   thumb_path = String.new(path)
      #   thumb_path.insert(-5, '-thumbnail')
      #   thumb.write(thumb_path)
      #   obj_thmb.write(Pathname.new(thumb_path), :acl => :public_read)

      #   note.uploaded_files.create(:public_path => obj.public_url.to_s, :page_number => i, :thumb_url => obj_thmb.public_url.to_s)
      # end
    rescue
      note.abort_processing!
    ensure
      # delete the PDF file and other files
      # File.delete(local_pdf_file)
      # converted_pages.each { |p| File.delete(p) }
      File.delete("document.htm")
      note.finish_processing!
    end
  end

  def remove_extra document
    document.css("script").remove
    document.css("style")[1].remove
    document.css(".loading-indicator").remove
    document.css("#sidebar").remove

    doc = File.new("document.htm", "w+")
    doc.puts document.to_html
  end
end