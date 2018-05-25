#!/usr/bin/env ruby

require 'yaml'
require 'twitter'
require 'table_print'

secrets = YAML.load_file('secrets.yml')

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = secrets['consumer_key']
  config.consumer_secret     = secrets['consumer_secret']
  config.access_token        = secrets['access_token']
  config.access_token_secret = secrets['access_token_key']
end

stats = Hash.new do |hash, key|
  hash[key] = OpenStruct.new(tweets: 0, retweets: 0, total: 0, user: key)
end

def collect_with_max_id(collection = [], max_id = nil, &block)
  response = block.call(max_id)
  collection += response
  response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def client.whole_home_timeline
  collect_with_max_id do |max_id|
    options = {count: 200, include_rts: true}
    options[:max_id] = max_id unless max_id.nil?

    begin
      home_timeline(options)
    rescue Twitter::Error::TooManyRequests => error
      # Might sleep for a long time but there's no better option.
      sleep error.rate_limit.reset_in + 1
      retry
    end
  end
end

client.whole_home_timeline.each do |tweet|
  # tweet.user.name for the display name
  user_stats = stats["@#{tweet.user.screen_name}"]

  if tweet.retweet?
    user_stats.retweets += 1
  else
    user_stats.tweets += 1
  end
  user_stats.total += 1
end

records = stats.each_value.sort_by { |value| -value.total }.to_a

tp.set :capitalize_headers, false
tp records, :user, :tweets, :retweets, :total
