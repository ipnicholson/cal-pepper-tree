#!/usr/bin/env ruby
# ^ above is not a comment, but a "hashbang" DO NOT DELETE

require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "tU8llLczxP76UeOHddlrd9pU4"
  config.consumer_secret     = "TQrwwKgP7OKfWzm1FHYPprVJAC21zrxUTYbnYlToUSUZWuB8uU"
  config.access_token        = "935720336686854144-WhESir4Erih3OCoHIkl5kIDDWEamgpb"
  config.access_token_secret = "7DFqLbl0L3yXnMda5o3RNs4XYUYaY0xSWSsl9flo15EDo"
end

reply_message = "Native plants are great! But, did you know the 'California' Pepper Tree is actually an invasive weed from Peru? More on this mixup: https://en.wikipedia.org/wiki/Schinus_molle"

search_options = {
  # result_type: "recent"
}

replied_to = Hash.new

client.search("#calpeppertreetest", search_options).each do |tweet|
  if tweet.user.screen_name != 'calpeppertree' # Don't reply to self
    puts "Matching result: #{tweet.user.screen_name}: #{tweet.text}"
    puts "User:#{tweet.user} Screen name:#{tweet.user.screen_name}"
    # client.update("@#{tweet.user.screen_name} #{reply_message}", in_reply_to_status_id: tweet.id)
    # puts tweet.id
    
    # replied_to[tweet.id] = 0
  end
end

puts replied_to

# search for tweets matching "california pepper tree" on time interval
# reply with stock message
# push tweet.id to replied-to tweets hash table
# exclude: 0) replied-to tweets 1) tweets from this account 2) replies to tweets from this account
