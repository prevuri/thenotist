class AboutController < ApplicationController
  def index
    render 'index', :layout => 'minimal'
  end
end
