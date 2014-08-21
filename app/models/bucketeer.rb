class Bucketeer < ActiveRecord::Base
  serialize :challenged_by, Array
  serialize :challenged, Array
end