class Note < ActiveRecord::Base
  attr_accessible :course_id, :description, :title, :user_id
  has_many :uploaded_files
  belongs_to :user

  def process (upload)
    file = upload[:file]
    name = file.original_filename
    directory = "public/data"

    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(file.read) }

    pages = RGhost::Convert.new(path).to :png, :resolution => 144, :multipage => true
    writePath = 'public/user_images'
    browserPath = '/user_images'
    
    FileUtils.move(pages, writePath)

    images = []
    pages.each do |imgPath|
      images << self.uploaded_files.create(:public_path => File.join(browserPath, File.basename(imgPath)))
    end
    return images
  end
end
