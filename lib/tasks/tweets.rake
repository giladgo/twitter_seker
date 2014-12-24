
namespace :tweets do
  def count_tweets(party, since_id=nil)
    search_term = "#{party.twitter_search_term} -rt"
    search_term = search_term + ' since:2014-12-01' unless since_id.nil?

    data = twitter_client.search(search_term, lang: 'he', include_entities: false, since_id: since_id).to_a

    [data.count, data.first.try(:id)]
  end

  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    end
  end

  task :init do
    Party.all.each do |party|
      puts "Fetching count for #{party.name}..."
      party.tweet_count, party.last_id = count_tweets(party)
      puts "#{party.tweet_count} tweets, last id is #{party.last_id}"
      party.save!
    end
  end

  task :update do
    Party.all.each do |party|
      puts "Fetching count for #{party.name} since #{party.last_id}"
      count, last_id = count_tweets(party, party.last_id)
      if count > 0
        party.tweet_count += count
        party.last_id = last_id
        puts "added #{party.tweet_count} tweets, last id is #{party.last_id}"
        party.save!
      else
        puts 'No new tweets'
      end
    end
  end
end
