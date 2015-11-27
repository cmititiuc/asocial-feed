#asocial-feed
Personal feed.  Post semi-private messages.

NOTE: No user can read another's messages, but the messages are stored in plain
text in the database.  Anyone who has access to the database can still read any
message.

##Setup on Ubuntu:

```bash
sudo apt-get install nodejs
sudo apt-get install -y libqtwebkit-dev qt4-qmake
sudo apt-get install libpq-dev
bundle install
sudo apt-get install postgresql
sudo vim.tiny /etc/postgresql/9.4/main/pg_hba.conf
```

```
local   all             postgres                                trust

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
```

```bash
sudo su - postgres
createuser -s asocial-feed
exit
bundle exec rake db:setup
bundle exec rails s
```
