namespace :db do
  desc 'Generate sample data'
  task :sample_data => :environment do
    # TODO find better way of doing this
    password = 'Password1'
    Rake::Task['db:reset'].invoke
    user = User.create({ :email => 'test@example.org', :password => password, :password_confirmation => password })
    tags = %w(Help Books Movies Ideas Exercise Journal)
    10.times do |count|
      tag = tags.sample
      body_text = (rand(3) != 0) ? ('Body text goes here. ' * 3) : ('Body text goes here. ' * 50)
      post = user.posts.create(:body => body_text)
      user.tag(post, :width => tag, :on => :tags)
      post.update_attributes(:created_at => Time.now - (rand(7) + 1 + count).days - (rand(24) + 1).hours)
    end
  end
end