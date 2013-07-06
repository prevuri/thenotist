require 'spec_helper'

describe Api::NotesController, "listing notes" do
  it "should render error if user is not authenticated" do
    post 'index'
  end
end