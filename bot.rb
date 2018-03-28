#!/usr/bin/env ruby

require 'yaml'
require 'csv'
require 'twitter'
require 'pp'

puts "running"

# Connected Twitter account
bot_account_id = 935720336686854144 # @calpeppertree

# Load credentials
account = YAML.load_file('secrets.yml')

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = account['consumer_key']
  config.consumer_secret     = account['consumer_secret']
  config.access_token        = account['access_token']
  config.access_token_secret = account['access_token_secret']
end

# Search terms for tweets to reply to
search_terms = "california pepper tree"

search_options = {
  # result_type: "recent"
}

# Message to reply with
reply_message = "Native plants are great! But, did you know the 'California' Pepper Tree is actually an invasive weed from Peru? More on this mixup: https://en.wikipedia.org/wiki/Schinus_molle"

# Keep list of previously replied-to tweets
replied_to = []
CSV.foreach("replied-to.csv") do |row|
  replied_to << row.first.to_i
end

# Reply to tweets matching search criteria
client.search(search_terms, search_options).each do |tweet|
  # Don't reply to self, don't reply if self has already replied
  if (tweet.user.id != bot_account_id && !replied_to.include?(tweet.id))
    puts "\nMatching result: \n#{tweet.created_at} \n#{tweet.user.screen_name}: #{tweet.text}"

    client.update("@#{tweet.user.screen_name} #{reply_message}", in_reply_to_status_id: tweet.id)

    CSV.open("replied-to.csv", "a") do |csv|
      csv << [tweet.id]
    end
  end
end