#!/usr/bin/env ruby
# ^ above is not a comment, but a "hashbang" DO NOT DELETE

require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "ufwCLj5pXohOSKijtDw8ZUtMn"
  config.consumer_secret     = "o4ykeL3GuQW8FJIn3ZQf0K5QbxedvglrzWf4DwZ8ehy1GwAX1n"
  config.access_token        = "935720336686854144-WhESir4Erih3OCoHIkl5kIDDWEamgpb"
  config.access_token_secret = "7DFqLbl0L3yXnMda5o3RNs4XYUYaY0xSWSsl9flo15EDo"
end

reply_message = "Native plants are great! But, did you know the 'California' Pepper Tree is actually an invasive weed from Peru? More on this mixup: https://en.wikipedia.org/wiki/Schinus_molle"

search_options = {
  result_type: "recent"
}

replied_to = {}

client.search("#calpeppertreetest", search_options).each do |tweet|
  puts "Matching result: #{tweet.user.screen_name}: #{tweet.text}"
  client.update("@#{tweet.user.screen_name} #{reply_message}", in_reply_to_status_id: tweet.id)
end

# search for tweets matching "california pepper tree" on time interval
# reply with stock message
# push tweet.id to replied-to tweets hash table
# exclude: 0) replied-to tweets 1) tweets from this account 2) replies to tweets from this account
