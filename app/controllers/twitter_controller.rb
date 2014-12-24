require 'twitter'

class TwitterController < ApplicationController

  def count_tweets
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ""
      config.consumer_secret = ""
    end

    party = params[:party]
    since_id = params[:since_id]
    data = client.search("#{party} -rt", lang: "he", include_entities: false, since_id: since_id).map do |tweet|
      {
        id: tweet.id,
        username: tweet.user.screen_name,
        text: tweet.text,
        date: tweet.created_at
      }
    end
    ap data.count

    render json: data
  end
end
