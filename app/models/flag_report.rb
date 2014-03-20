class FlagReport < ActiveRecord::Base
  attr_accessible :description, :doc_removed, :report_resolved, :report_type, :user
  belongs_to :note
  belongs_to :user

  def as_json
    {
      :id => id,
      :created_at => created_at.to_formatted_s(:long_ordinal),
      :description => description,
      :note => note.as_json,
      :doc_removed => doc_removed,
      :report_resolved => report_resolved,
      :report_type => report_type
    }
  end
end
