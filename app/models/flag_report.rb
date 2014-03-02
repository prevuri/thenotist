class FlagReport < ActiveRecord::Base
  attr_accessible :description, :doc_removed, :report_resolved, :report_type
  belongs_to :note

  def as_json
    {
      :created_at => created_at, 
      :description => description, 
      :note => note.as_json,
      :doc_removed => doc_removed,
      :report_resolved => report_resolved,
      :report_type => report_type
    }
  end
end
