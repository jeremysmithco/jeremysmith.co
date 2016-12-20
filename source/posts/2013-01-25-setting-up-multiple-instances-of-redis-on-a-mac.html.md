---
title: Setting up multiple instances of Redis on a Mac
date: 2013-01-25 11:50 UTC
tags: ruby
---

I'm using [Redis](http://redis.io) on a project and couldn't find a good guide for setting up multiple instances on a Mac. So, I decided to write up how I did it. (You might want this if you need one instance for development and a separate instance for running your test suite.)

1\. Install [Homebrew](http://mxcl.github.com/homebrew/) (great package manager for OS X)

2\. Install Redis package with Homebrew

```
brew install redis
```

3\. Create separate config files for your instances (in my example, a dev and a test instance).

Rename /usr/local/etc/redis.conf to /usr/local/etc/redis-dev.conf and change the following settings:

```
daemonize yes
pidfile /usr/local/var/run/redis-dev.pid
logfile /usr/local/var/log/redis-dev.log
dbfilename dump-dev.rdb
```

Copy that redis-dev.conf and save redis-test.conf and change the following settings:

```
pidfile /usr/local/var/run/redis-test.pid
port 6380
logfile /usr/local/var/log/redis-test.log
dbfilename dump-test.rdb
```

Grab this [Redis Startup Item](https://github.com/chris/redis-startupitem-osx/) git repo and change the following settings (then follow the instructions to install):

```
DEV_CONF_FILE="/usr/local/etc/redis-dev.conf"
TEST_CONF_FILE="/usr/local/etc/redis-test.conf"

StartService
$REDIS $DEV_CONF_FILE
$REDIS $TEST_CONF_FILE

StopService
for pid in $(ps -o pid,command -ax | grep redis-server | awk '!/awk/ && !/grep/ {print $1}')
do
    kill -2 $pid
done
```

You may have to set proper ownership on the redis folder, as well:

```
cd /Library/StartupItems
sudo chown -R root:wheel redis/
```

Here are a couple links that helped me along the way:

* http://stackoverflow.com/questions/5148390/redis-databases-on-a-dev-machine-with-multiple-projects
* http://chrislaskey.com/blog/342/running-multiple-redis-instances-on-the-same-server/
