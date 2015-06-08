namespace :db do
  desc 'Generate sample data'
  task :sample_data => :environment do
    # TODO find better way of doing this
    password = 'Password1'
    Rake::Task['db:reset'].invoke
    user = User.create({ :email => 'test@example.org', :password => password, :password_confirmation => password })
    topics = %w(Help Books Movies Ideas Exercise Journal)
    topics.each do |topic|
      user.topics.create(:name => topic)
    end
    10.times do |count|
      topic = Topic.all.sample
      body_text = (rand(3) != 0) ? ('Body text goes here. ' * 3) : ('Body text goes here. ' * 50)
      post = user.posts.create(:body => body_text, :topic => topic)
      post.update_attributes(:created_at => Time.now - (rand(7) + 1 + count).days - (rand(24) + 1).hours)
    end
  end
end