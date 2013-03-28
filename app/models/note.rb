class Note < ActiveRecord::Base
  attr_accessible :description, :title

  belongs_to :user
  has_many :uploaded_files, :dependent => :destroy
  has_many :comments, :through => :uploaded_files

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

    File.delete(path)
    return images
  end
end
