class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  default_scope -> { order('created_at DESC') }
  validates :body, :length => { minimum: 1 }
  scope :topic_id, lambda { |topic_id| topic_id == 'nil' ? where('topic_id IS NULL') : where('topic_id = ?', topic_id) }
end
