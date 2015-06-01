class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  default_scope -> { order('created_at DESC') }
  validates :body, :length=>{ minimum: 1 }
end
