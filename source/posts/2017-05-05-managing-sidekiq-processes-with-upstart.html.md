---
title: Managing Sidekiq Processes with Upstart
date: 2017-05-05 17:42 UTC
tags: rails, linux
---

I normally use [resque](https://github.com/resque/resque) for background jobs in Rails (with [capistrano-resque](https://github.com/sshingler/capistrano-resque) for managing resque processes). But I decided to switch to [Sidekiq](https://github.com/mperham/sidekiq) on a new application.

I spent some time familiarizing myself with the best practices and came across [this post](http://www.mikeperham.com/2015/07/16/sidekiq-and-upstart/) by Mike Perham, Sidekiq's author.

> The best and most reliable way to manage multiple Sidekiq processes is with Upstart. Many developers know little to nothing about Upstart so I wanted to write up how to integrate Sidekiq with Upstart.

> Deployment should do two things: quiet Sidekiq as early as possible and restart as late as possible.

> We don't need to daemonize. Modern daemons should never daemonize themselves.

> We don't need PID files. PID files are legacy from years ago and their use should signal that something is wrong.

> In other words, stop reinventing the wheel and let the operating system do the hard work for you!

The big takeaway for me was that I should be treating Upstart as a first-class tool that I rely on for managing processes, instead of finding ways around it. Capistrano should be doing as little as possible to simply ensure that the appropriate processes are restarted when a deployment requires code to be reloaded.

I took the example scripts provided, and [a set of scripts I found](https://github.com/lemurheavy/sidekiq_test/tree/master/examples/upstart/manage-many) to manage many Sidekiq services, and modified them for my needs:

I set up `/etc/init/appname-workers.conf` to manage the Sidekiq workers specifically for my application. (If I have another application on the same server, I'll just create another config file like this.)

```
description "Manages APPNAME Sidekiq workers"

start on runlevel [2345]
stop on runlevel [06]

pre-start script
  start sidekiq app=appname index=0
end script

post-stop script
  stop sidekiq app=appname index=0
end script
```

I added `/etc/init/sidekiq.conf` to start an individual Sidekiq worker (called by the script above).

```
description "Sidekiq Background Worker"

setuid deploy
setgid deploy
env HOME=/home/deploy

respawn
respawn limit 3 30
normal exit 0 TERM
kill timeout 15

instance ${app}-${index}

script
exec /bin/bash <<'EOT'
  source /home/deploy/.rvm/scripts/rvm
  logger -t sidekiq "Starting process: $app-$index"

  cd /var/www/${app}/current
  exec bundle exec sidekiq -i ${index} -e production
EOT
end script
```

Then, in my Rails application, I added the following to my `config/deploy.rb`

```
namespace :sidekiq do
  task :quiet do
    on roles(:app) do
      puts capture("pgrep -f 'sidekiq (.*) appname' | xargs kill -USR1")
    end
  end

  task :restart do
    on roles(:app) do
      sudo 'restart appname-workers'
    end
  end
end

after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:reverted', 'sidekiq:restart'
after 'deploy:published', 'sidekiq:restart'
```

I anticipate that I may have multiple applications using sidekiq on this same server, so I changed the `:quiet` task to find the process with both sidekiq and appname in the name: `pgrep -f 'sidekiq (.*) appname'`

Because my `deploy` user is going to restart the `appname-workers` script, I needed to add password-less sudo permissions specifically for the `restart appname-workers` command by adding a file to be included in sudoers: `/etc/sudoers.d/appname-workers_deploy`

```
deploy ALL=NOPASSWD:/sbin/restart appname-workers
```

[Capistrano's documentation](http://capistranorb.com/documentation/getting-started/authentication-and-authorisation/#authorisation) was helpful in understanding how this should be done.
