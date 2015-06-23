class TopicsToTags < ActiveRecord::Migration
  def up
    Post.all.each do |post|
      post.user.tag(post, :with => Topic.find(post.topic_id).name, :on => :tags)
    end
    remove_index :posts, :topic_id
    remove_index :topics, :user_id
    remove_foreign_key :posts, :topics
    remove_foreign_key :topics, :users
    remove_column :posts, :topic_id, :integer
    drop_table :topics
  end

  def down
    create_table :topics do |t|
      t.column :name, :string
      t.references :user
    end
    add_reference :posts, :topic
    add_index :posts, :topic_id
    add_index :topics, :user_id
    add_foreign_key :posts, :topics
    add_foreign_key :topics, :users
    Post.all.each do |post|
      topic = Topic.create(:user_id => post.user_id, :name => post.tags.first.name) if post.tags.first
      post.update_attributes(:topic_id => topic.id)
      post.taggings.destroy_all
    end
  end
end
