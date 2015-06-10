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

  def sample_data
    movie_topic = topics.create(:name => 'Movies')
    movies = [
      "The Princess Bride\n\n*Film Noir*\n\nThe Big Head\n-The Big Sleep-",
      "Memento\nVertigo (Hitchcock)",
      "# Teenage Mutant Ninja Turtles\n# Secret of the Ooze\n# Turtles in Time\n\n* -Serenity-\n* Solaris\n* -Jodorowsky's Dune-"
    ]
    movies.each_with_index do |movie, index|
      post = posts.create(:body => movie, :topic => movie_topic)
      post.update_attributes(:created_at => Time.now - (rand(7) + 1 + index).days - (rand(24) + 1).hours - rand(60).minutes)
    end

    book_topic = topics.create(:name => 'Books')
    books = [
      "-The Old Man and the Sea-",
      "Victorian Literature\n\n* David Copperfield\n* Oliver Twist\n* Hard Times\n* Jane Eyre _(considered Romantic, not Victorian?)_\n* The Mill on the Floss",
      "-Moby Dick-",
      "-A Brief History of Time - Stephen Hawking-"
    ]
    books.each_with_index do |book, index|
      post = posts.create(:body => book, :topic => book_topic)
      post.update_attributes(:created_at => Time.now - (rand(7) + 1 + index).days - (rand(24) + 1).hours - rand(60).minutes)
    end

    exercise_topic = topics.create(:name => 'Exercise')
    exercises = [
      "Rode the bike for 30 minutes",
      "Jogged on the street for 15 minutes",
      "Jogged on the treadmill at speed 4.0 for 15 minutes\n\nWasn't too bad.  Do again next time."
    ]
    exercises.each_with_index do |exercise, index|
      post = posts.create(:body => exercise, :topic => exercise_topic)
      post.update_attributes(:created_at => Time.now - (rand(7) + 1 + index).days - (rand(24) + 1).hours - rand(60).minutes)
    end

    post = posts.create(:body => "Chores\n\n* -Laundry-\n* -Dishes-\n* -Vacuum-")
    post.update_attributes(:created_at => Time.now - (rand(7) + 1).days - (rand(24) + 1).hours - rand(60).minutes)
    post = posts.create(:body => "Tar command I always forget:\n\npre. @tar xvzf filename.tar.gz@")
    post.update_attributes(:created_at => Time.now - (rand(7) + 1).days - (rand(24) + 1).hours - rand(60).minutes)
    post = posts.create(:body => "Replaced rotors on car")
    post.update_attributes(:created_at => Time.now - (rand(7) + 1).days - (rand(24) + 1).hours - rand(60).minutes)

    message = <<EOS
Hello!

Thank you for your interest in asocial-feed. It's a simple way to record personal messages and ideas without having to worry about what others may think of them.  Also, because it's online, you can access your personal feed from anywhere with internet access!

Since you are signed in as a guest, we've filled in some examples of use below.
EOS
    posts.create(:body => message)
  end
end
