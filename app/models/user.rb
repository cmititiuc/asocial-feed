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
    samples = {}
    samples[:none] = []
    samples[:none] << "Chores\n\n* -Laundry-\n* -Dishes-\n* -Vacuum-"
    samples[:none] << "Tar command I always forget:\n\npre. tar xvzf filename.tar.gz"
    samples[:none] << "Replaced rotors on car"

    samples[:exercise] = []
    samples[:exercise] << "Rode the bike for 30 minutes"
    samples[:exercise] << "Jogged on the street for 15 minutes"
    samples[:exercise] << "Jogged on the treadmill at speed 4.0 for 15 minutes\n\nWasn't too bad.  Do again next time."

    samples[:books] = []
    samples[:books] << "-The Old Man and the Sea-"
    samples[:books] << "Victorian Literature\n\n* David Copperfield\n* Oliver Twist\n* Hard Times\n* Jane Eyre _(considered Romantic, not Victorian?)_\n* The Mill on the Floss"
    samples[:books] << "-Moby Dick-"
    samples[:books] << "-A Brief History of Time - Stephen Hawking-"

    samples[:movies] = []
    samples[:movies] << "The Princess Bride\n\n*Film Noir*\n\nThe Big Heat\n-The Big Sleep-"
    samples[:movies] << "Memento\nVertigo (Hitchcock)"
    samples[:movies] << "# Teenage Mutant Ninja Turtles\n# Secret of the Ooze\n# Turtles in Time\n\n* -Serenity-\n* Solaris\n* -Jodorowsky's Dune-"
    
    create_samples samples

    message = <<EOS
Hello!

Thank you for your interest in asocial-feed. It's a simple way to record personal messages and ideas without having to worry about what others may think of them.  Also, because it's online, you can access your personal feed from anywhere with internet access!

Since you are signed in as a guest, we've filled in some examples of use below.
EOS
    posts.create(:body => message)
  end

  private

  def create_samples(samples)
    samples.each do |key, values|
      if key == :none
        values.each do |value|
          posts.create(
            :body => value,
            :created_at => random_date
          )
        end
      else
        topic = topics.create(:name => key.to_s.humanize.titleize)
        values.each_with_index do |value, index|
          posts.create(
            :body => value,
            :topic => topic,
            :created_at => random_date(index)
          )
        end
      end
    end
  end

  def random_date(index = 0)
    now = Time.now
    d = rand(7) + 1 + index
    h = rand(24) + 1
    m = rand(60)
    now - d.days - h.hours - m.minutes
  end
end
