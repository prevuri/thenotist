# require 'RMagick'
# include Magick

class Note < ActiveRecord::Base
  attr_accessible :description, :title, :processed, :aborted, :processing_started_at

  belongs_to :user
  has_many :contributors, foreign_key: "shared_note_id", dependent: :destroy
  has_many :contributing_users, through: :contributors, source: :user
  #What was this made for? contibutors should cover this #What was this made for?
  has_many :uploaded_html_files, dependent: :destroy
  has_many :uploaded_css_files, dependent: :destroy
  has_many :comments, :through => :uploaded_html_files

  # want to assume that we are processing a file right away
  before_create :start_processing!

  def finish_processing!
    self.update_attribute :processed, true
  end

  def abort_processing!
    self.update_attribute :aborted, true
  end

  def processing_timeout?
    start_time = self.processing_started_at.nil? ? Time.now : self.processing_started_at
    !processed && (Time.now - start_time > 10.minutes)
  end


  def share! user
    contributors.create!(user_id: user.id)
  end

  def shared_with? user
    contributors.find_by_user_id(user.id)
  end

  def revoke_share! user
    contributors.find_by_user_id(user.id).destroy
  end

  def noncontributors user
    nc = user.buddies - contributing_users
    nonContrib = Hash.new

    nc.each do |n|
      nonContrib[n.id] = n.name
    end
    nonContrib
  end

  def is_contributor? user
    contributors.each do |con|
      if con.has_user? user
        return true
      end
    end
    return false
  end

  def as_json
    {
      :id => id,
      :title => title,
      :description => description,
      :uploaded_html_files => uploaded_html_files.map { |f| f.as_json },
      :uploaded_css_files => uploaded_css_files.map { |f| f.as_json },
      :user => user.as_json,
      :processed => processed,
      :aborted => aborted,
      :processing_started_at => processing_started_at,
      :created_at => created_at,
      :comment_count => comment_count()
    }
  end

private
  def start_processing!
    self.processing_started_at = Time.now
  end

  def comment_count
    total = 0
    uploaded_html_files.each{ |f| total += f.comments.length }
    total
  end
end
