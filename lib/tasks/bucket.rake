require 'open-uri'
require_relative 'rake_helper'

namespace :ibc do
  desc 'Create list of bucketeers from Wikipedia page'
  task bucket_list: :environment do

    source = 'http://en.wikipedia.org/wiki/List_of_Ice_Bucket_Challenge_participants'
    target = Rails.root.join('db/bucket_list.txt')
    html = Nokogiri::HTML(open(source))
    raw_bucket_list = html.css('.div-col li').map(&:text)
    bucket_list = raw_bucket_list.map { |name| name.split('[')[0] }.uniq

    File.open(target, 'w') do |file|
      bucket_list.each { |name| file.puts name }
    end
  end

  desc 'Add every name in bucket list to DB'
  task insert_bucketeers: :environment do
    source = Rails.root.join('db/bucket_list.txt')
    iteration = 0

    puts 'Adding listed bucketeers to database. This may take a while...'
    puts Time.now.strftime('%I:%M%p on %a %m/%d/%Y')

    File.open(source).each_line do |name|
      identity = name.chomp.delete(%q{-,.'" })
      user = $client.user_search(name).first.try(:screen_name) || identity
      iteration += 1
      puts "Adding bucketeer #{iteration}: #{user}"
      Bucketeer.create(name: name.chomp, identifier: user)
      sleep 1.minute if iteration % 10 == 0
    end

    puts 'Bucketeer insertion into database successful.'
    puts Time.now.strftime('%I:%M%p on %a %m/%d/%Y')
  end

  desc 'Fetch relevant tweets for all bucketeers'
  task fetch_tweets: :environment do
    MAX = 200
    n_tweets = 5
    iteration = 0
    options = { count: MAX }
    bucketeers = Bucketeer.select { |b| b.identifier if b.tweets.empty? }

    puts 'Fetching tweets. This may take a while...'
    puts Time.now.strftime('%I:%M%p on %a %m/%d/%Y')

    bucketeers.each do |bucketeer|
      iteration += 1
      sleep 1.minute if iteration % 10 == 0

      puts "Processing bucketeer #{iteration}: #{bucketeer.name}"
      begin
        tweets =
        $client.user_timeline(bucketeer.identifier, options).select do |t|
          t.text =~ /ice\s?bucket|tak(e|es|ing)\s?ice/i
        end.last(n_tweets)
      rescue => e
        puts "Something went wrong fetching #{bucketeer.name}'s tweets."
        puts "*** Exception: #{e.message} ***"
        next
      end

      puts "Adding #{bucketeer.name}'s tweets to database"
      tweets.each { |tweet| RakeHelper::tweet_creator(tweet, bucketeer.id) }
    end

    puts
    puts 'Database update complete'
    puts Time.now.strftime('%I:%M%p on %a %m/%d/%Y')
  end

  desc 'Create a YAML file of the bucketeers'
  task write_yml: :environment do
    target = Rails.root.join('db/bucket_list.yml')
    puts "Writing #{target.basename} to db/..."

    File.open(target, 'w') do |file|
      file.puts 'bucketeers:'
      Bucketeer.all.each do |bucketeer|
        file.puts "  - name: #{bucketeer.name}"
        file.puts "    identifier: #{bucketeer.identifier}"
        file.puts "    challenged_by:"
        file.puts "    challenged:"

        nexus = bucketeer.tweets.map(&:user_mentions)
                         .flatten.map { |u| u[:screen_name] }.uniq
        nexus.each do |conn|
          file.puts "      - #{conn}"
        end

        file.puts "    media_link:"
        urls = bucketeer.tweets.map(&:urls).flatten.uniq
        urls.each do |url|
          file.puts "      - #{url}"
        end
        file.puts
      end
    end
    puts "#{target.basename} written"
  end
end