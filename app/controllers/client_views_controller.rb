class ClientViewsController < ApplicationController
  def show
    render params[:id], layout: nil
  end
end

