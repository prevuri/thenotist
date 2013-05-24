class Note < ActiveRecord::Base
  attr_accessible :description, :title

  belongs_to :user
  has_many :uploaded_files, :dependent => :destroy
  has_many :comments, :through => :uploaded_files

  def process (upload)
    # create a random name for the uploaded file
    local_pdf_file = File.join("private/user_uploads", SecureRandom.uuid)

    # get the uploaded file
    File.open(local_pdf_file, "wb") { |f| f.write(upload[:file].read) }

    # PDF -> PNG
    converted_pages = RGhost::Convert.new(local_pdf_file).to :png, :resolution => 144, :multipage => true

    # local -> S3 (AWS creds should be initialized already)
    # and create models
    bucket = AWS::S3.new.buckets['thenotist']
    images = []
    converted_pages.each_with_index do |path, i|
      obj = bucket.objects["image_store/#{SecureRandom.uuid}.png"]
      obj.write(Pathname.new(path), :acl => :public_read)
      images << self.uploaded_files.create(:public_path => obj.public_url.to_s, :page_number => i)
    end

    # delete the PDF file and other files
    File.delete(local_pdf_file)
    converted_pages.each { |p| File.delete(p) }
    return images
  end

  def as_json
    {
      :title => title,
      :description => description,
      :uploaded_files => uploaded_files.map { |f| f.as_json },
      :user => user.as_json
    }
  end
end
