class AdminController < ApplicationController
  def index
    @user = User.all
    @notes = Note.all
  end
end
