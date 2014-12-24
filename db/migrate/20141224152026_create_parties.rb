class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.string :twitter_search_term
      t.integer :tweet_count
      t.integer :last_id
      t.timestamps
    end
  end
end
