#!/usr/bin/env ruby

require 'yaml'
require 'csv'
require 'twitter'
require 'pp'

puts "Running!"

# Load credentials
account = YAML.load_file('secrets.yml')

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = account['consumer_key']
  config.consumer_secret     = account['consumer_secret']
  config.access_token        = account['access_token']
  config.access_token_secret = account['access_token_secret']
end

bot_account_id = client.user.id

puts "\nBot Account: @#{client.user.screen_name}"

# Search terms for tweets to reply to
search_terms = "california pepper tree"

puts "\nSearch Terms: \"#{search_terms}\""

# Search options. See Twitter API docs
search_options = {
  # result_type: "recent"
}

# Message to reply with
reply_message = "Native plants are great! But, did you know the 'California' Pepper Tree is actually an invasive weed from Peru? More on this mixup: https://en.wikipedia.org/wiki/Schinus_molle"

# Array of previously replied-to tweets
replied_to = []

CSV.foreach("replied-to.csv") do |row|
  replied_to << row.first.to_i
end

# Reply to tweets matching search criteria
client.search(search_terms, search_options).each do |tweet|
  # Don't reply to self, and don't reply if self has already replied to that tweet
  if (tweet.user.id != bot_account_id && !replied_to.include?(tweet.id))
    begin
      puts "\nMatching result: \n#{tweet.created_at} \n#{tweet.user.screen_name}: #{tweet.text}"
      client.update("@#{tweet.user.screen_name} #{reply_message}", in_reply_to_status_id: tweet.id)

    # Error handling
    rescue Exception => error
      puts "\nError:"
      pp error.message

    # Log to CSV if no errors
    else
      CSV.open("replied-to.csv", "a") do |csv|
        csv << [tweet.id, tweet.user.screen_name]
      end
    end
  end

end