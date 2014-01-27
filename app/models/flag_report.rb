class FlagReport < ActiveRecord::Base
  attr_accessible :created_at, :description, :doc_id, :doc_removed, :doc_title, :report_id, :report_resolved

  belongs_to :note
end
