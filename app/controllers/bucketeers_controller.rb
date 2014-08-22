class BucketeersController < ApplicationController
  def index
    @bucketeers = Bucketeer.all
  end

  def show
    @bucketeer = Bucketeer.find_by_identifier(params[:id])
  end
end