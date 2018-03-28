#!/usr/bin/env ruby

require 'yaml'
require 'csv'
require 'twitter'
require 'pp'

puts "\nrunning"

puts "\n"

account = YAML.load_file('./secrets.yml')

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = account['consumer_key']
  config.consumer_secret     = account['consumer_secret']
  config.access_token        = account['access_token']
  config.access_token_secret = account['access_token_secret']
end

# tweets = client.user_timeline('calpeppertree', count: 12)

tweets = client.search("california pepper tree")

tweets.each do |tweet|
  puts "\n"
  pp tweet.created_at
  pp tweet.user.screen_name
  pp tweet.id
  pp tweet.full_text
end

# write Tweet ID to CSV file
CSV.open("practice.csv", "wb") do |csv|
  tweets.each do |tweet|
    csv.add_row([tweet.id])
  end
end


