class Tweet < ActiveRecord::Base
  serialize :hashtags, Array
  serialize :urls, Array
  serialize :user_mentions, Array
  serialize :tweeter_profile_image_url, Addressable::URI

  validates_uniqueness_of :tweet_id

  belongs_to :bucketeer
end