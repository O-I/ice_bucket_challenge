class Bucketeer < ActiveRecord::Base
  serialize :challenged_by, Array
  serialize :challenged, Array

  validates_uniqueness_of :identifier

  has_many :tweets
end