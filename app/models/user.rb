class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable
  has_many :topics, :dependent => :destroy
  has_many :posts, :dependent => :destroy

  def self.destroy_guests
    where(:encrypted_password => "").destroy_all
  end
end
