class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        guest_user(with_retry = false).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  def guest
    guest_user
    movie_topic = guest_user.topics.create(:name => 'Movies')
    movies = [
      "The Princess Bride\n\n*Film Noir*\n\nThe Big Head\n-The Big Sleep-",
      "Honey I Shrunk the Kids",
      "# Teenage Mutant Ninja Turtles\n# Secret of the Ooze\n# Turtles in Time\n\n* -Serenity-\n* Solaris\n* -Jodorowsky's Dune-"
    ]
    movies.each_with_index do |movie, index|
      post = guest_user.posts.create(:body => movie, :topic => movie_topic)
      post.update_attributes(:created_at => Time.now - (rand(7) + 1 + index).days - (rand(24) + 1).hours - rand(60).minutes)
    end
    book_topic = guest_user.topics.create(:name => 'Books')
    books = [
      "-The Old Man and the Sea-",
      "Victorian Literature\n\n* David Copperfield\n* Oliver Twist\n* Hard Times\n* Jane Eyre _(considered Romantic, not Victorian?)_\n* The Mill on the Floss",
      "-Moby Dick-",
      "-A Brief History of Time - Stephen Hawking-"
    ]
    books.each_with_index do |book, index|
      post = guest_user.posts.create(:body => book, :topic => book_topic)
      post.update_attributes(:created_at => Time.now - (rand(7) + 1 + index).days - (rand(24) + 1).hours - rand(60).minutes)
    end
    exercise_topic = guest_user.topics.create(:name => 'Exercise')
    exercises = [
      "Rode the bike for 30 minutes",
      "Jogged on the street for 15 minutes",
      "Jogged on the treadmill at speed 4.0 for 15 minutes\n\nWasn't too bad.  Do again next time."
    ]
    exercises.each_with_index do |exercise, index|
      post = guest_user.posts.create(:body => exercise, :topic => exercise_topic)
      post.update_attributes(:created_at => Time.now - (rand(7) + 1 + index).days - (rand(24) + 1).hours - rand(60).minutes)
    end
    post = guest_user.posts.create(:body => "Chores\n\n* -Laundry-\n* -Dishes-\n* -Vacuum-")
    post.update_attributes(:created_at => Time.now - (rand(7) + 1).days - (rand(24) + 1).hours - rand(60).minutes)
    post = guest_user.posts.create(:body => "Tar command I always forget:\n\n@tar xvzf filename.tar.gz@")
    post.update_attributes(:created_at => Time.now - (rand(7) + 1).days - (rand(24) + 1).hours - rand(60).minutes)

    message = <<EOS
Hello!

Thank you for your interest in asocial-feed. It's a simple way to record personal messages and ideas without having to worry about what others may think of them.  Also, because it's online, you can access your personal feed from anywhere with internet access!

Since you are signed in as a guest, we've filled in some examples of use below.
EOS
    guest_user.posts.create(:body => message)

    redirect_to root_path
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
      # comment.user_id = current_user.id
      # comment.save!
    # end
  end

  def create_guest_user
    u = User.create(:email => "guest_#{Time.now.to_i}#{rand(100)}@example.org")
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end
end
