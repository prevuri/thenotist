class Note < ActiveRecord::Base
  include ApplicationHelper

  attr_accessible :title, :processed, :aborted

  belongs_to :user
  has_many :contributors, foreign_key: "shared_note_id", dependent: :destroy
  has_many :contributing_users, through: :contributors, source: :user
  #What was this made for? contibutors should cover this #What was this made for?

  has_many :uploaded_html_files, dependent: :destroy, :order => 'page_number ASC'
  has_many :uploaded_css_files, dependent: :destroy, :order => 'id ASC'
  has_many :uploaded_thumb_files, dependent: :destroy, :order => 'page_number ASC'

  has_many :comments, :through => :uploaded_html_files
  has_many :tags

  def finish_processing!
    self.update_attribute :processed, true
  end

  def abort_processing!
    self.update_attribute :aborted, true
  end

  def abort_if_timed_out!
    abort_processing! if !processed && (Time.now - created_at > 120.minutes)
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

  def parent_comments
    return self.comments.where(:parent_comment_id => nil)
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

  def as_json user
    {
      :id => id,
      :title => title,
      :contributing_users => contributing_users.map(&:as_json),
      :uploaded_html_files => uploaded_html_files.map(&:as_json),
      :uploaded_css_files => uploaded_css_files.map(&:as_json),
      :uploaded_thumb_files => uploaded_thumb_files.map(&:as_json),
      :user => user.as_json,
      :processed => processed,
      :aborted => aborted,
      :created_at => created_at,
      :tags => tags_for_user(user).map(&:as_json)
    }
  end

    def as_private_json
    {
      :id => id,
      :title => title,
      :contributing_users => contributing_users.map { |u| u.as_json },
      :user => user.as_json,
      :created_at => created_at,
      :processed => processed,
      :comment_count => comment_count()
    }
  end

  def tags_for_user user
    self.tags.where(:user_id => user.id)
  end

private

  def comment_count
    self.comments.count
  end

end
