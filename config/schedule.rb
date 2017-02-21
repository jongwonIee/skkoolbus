# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
every '* 7-20 * * *' do
   command "cd /Users/Joseph/rails_project/skkoolbus && RAILS_ENV=development bundle exec rake parsing:bus --silent"
end
for i in (1..11) do
  every '* 7-20 * * *' do
     command "sleep #{i*5}; cd /Users/Joseph/rails_project/skkoolbus && RAILS_ENV=development bundle exec rake parsing:bus --silent"
  end
end
every '0 0 * * *' do
  command 'cat /dev/null > /var/mail/Joseph'
end
# Learn more: http://github.com/javan/whenever
