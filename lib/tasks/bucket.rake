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
end