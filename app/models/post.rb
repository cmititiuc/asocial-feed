class Post < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user

  default_scope -> { order('created_at DESC') }
  validates :body, :length => { minimum: 1 }
end
