require 'open-uri'

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

  desc 'Adds every name in bucket list to DB'
  task insert_bucketeers: :environment do
    source = Rails.root.join('db/bucket_list.txt')
    iteration = 0
    bucketeers = []

    puts 'Adding listed bucketeers to database. This may take a while...'
    puts Time.now.strftime('%I:%M%p on %a %m/%d/%Y')

    File.open(source).each_line do |name|
      identity = name.delete(%q{-,.'" })
      user = $client.user_search(name).first.try(:screen_name) || identity
      iteration += 1
      puts "Adding bucketeer #{iteration} #{user}"
      Bucketeer.create(name: name, identifier: user)
      sleep 1.minute if iteration % 10 == 0
    end

    puts 'Bucketeer insertion into database successful.'
    puts Time.now.strftime('%I:%M%p on %a %m/%d/%Y')
  end
end