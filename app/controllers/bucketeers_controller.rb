class BucketeersController < ApplicationController
  def index
    @bucketeers = Bucketeer.all
  end
end
