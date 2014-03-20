class Note < ActiveRecord::Base
  attr_accessible :title, :processed, :aborted, :flagged
  belongs_to :user
  has_many :contributors, foreign_key: "shared_note_id", dependent: :destroy
  has_many :contributing_users, through: :contributors, source: :user
  has_many :uploaded_html_files, dependent: :destroy, :order => 'page_number ASC'
  has_many :uploaded_css_files, dependent: :destroy, :order => 'id ASC'
  has_many :uploaded_thumb_files, dependent: :destroy, :order => 'page_number ASC'
  has_many :flag_reports
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
    contributors.where(:user_id => user.id).count != 0
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

  def as_json_for_index current_user
    if (self.user.id == current_user.id || self.shared_with?(current_user))
      return {
        :id => id,
        :title => title,
        :contributing_users => contributing_users.map(&:as_json),
        :uploaded_thumb_files => uploaded_thumb_files.map(&:as_json),
        :user => user.as_json,
        :processed => processed,
        :aborted => aborted,
        :created_at => created_at,
        :tags => tags_for_user(current_user).map(&:as_json),
        :flagged => flagged,
        :accessible => true,
        :is_owner => self.user == current_user
      }
    else
      return {
        :id => id,
        :accessible => false,
        :user => user.as_json,
        :created_at => created_at,
        :is_owner => self.user == current_user
      }
    end
  end

  def as_json current_user
    if (self.user.id == current_user.id || self.shared_with?(current_user))
      return {
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
        :tags => tags_for_user(current_user).map(&:as_json),
        :flagged => flagged,
        :accessible => true,
        :is_owner => self.user == current_user
      }
    else
      return {
        :id => id,
        :accessible => false,
        :user => user.as_json,
        :created_at => created_at,
        :is_owner => self.user == current_user
      }
    end
  end

  def tags_for_user current_user
    self.tags.where(:user_id => current_user.id)
  end

private

  def comment_count
    self.comments.count
  end

end
