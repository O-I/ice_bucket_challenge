class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_id, unique: true
      t.datetime :tweet_date
      t.text :tweet_text
      t.string :tweeter_id
      t.string :tweeter_name
      t.string :tweeter_screen_name
      t.string :tweeter_location
      t.text :tweeter_profile_image_url
      t.integer :retweet_count
      t.integer :favorite_count
      t.text :hashtags
      t.text :urls
      t.text :user_mentions
      t.belongs_to :bucketeer
      t.timestamps
    end
  end
end
