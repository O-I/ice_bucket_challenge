module RakeHelper
  def self.tweet_creator(tweet, bucketeer_id)
    Tweet.create(
      tweet_id: tweet.id,
      tweet_date: tweet.created_at,
      tweet_text: tweet.text,
      tweeter_id: tweet.user.id,
      tweeter_name: tweet.user.name,
      tweeter_screen_name: tweet.user.screen_name,
      tweeter_location: tweet.user.location,
      tweeter_profile_image_url: tweet.user.profile_image_url_https,
      retweet_count: tweet.retweet_count,
      favorite_count: tweet.favorite_count,
      hashtags: tweet.attrs[:entities][:hashtags].map do |hashtag|
                  hashtag[:text]
                end,
      urls: tweet.attrs[:entities][:urls].map do |url|
              url[:expanded_url]
            end,
      user_mentions: tweet.attrs[:entities][:user_mentions].map do |at|
                       { screen_name: at[:screen_name],
                         name: at[:name],
                         id: at[:id]
                       }
                     end,
      bucketeer_id: bucketeer_id)
  end
end