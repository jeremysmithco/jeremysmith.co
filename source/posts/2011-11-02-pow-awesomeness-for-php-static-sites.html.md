---
title: Pow Awesomeness for PHP & Static Sites
date: 2011-11-02 1:24 UTC
tags: ruby
---

I recently started using [Pow](http://pow.cx/) for my Rails apps in development. Pow is a "zero-config Rack server for Mac OS X" that makes it a cinch to access your Rails apps by individual host name and without having to futz with /etc/hosts or funky ports. Just create a quick symlink to your apps' directory and then go to appname.dev in your browser!

Problem is, if you're using Pow, you're going to have trouble hitting plain-old Apache for those PHP or static sites you are working on.

In my case, I'm working on multiple front-end development projects at once, and they often start in plain HTML/CSS. But to get them working with web font services, like Typekit, and to be able to do testing on other platforms (e.g. Windows through a virtual machine), I need them served up by a web server.

So what can be done? I did some googling and came across [Ted Kulp's post](http://tedkulp.com/using-pow-for-php-or-anything-on-apache/) on this very issue.

Basically, you switch Apache to listen on port 8080, and then create a config.ru file somewhere that acts as a proxy to Apache.

I took his code and modified it slightly to fit my own needs.

```
#http://tedkulp.com/using-pow-for-php-or-anything-on-apache/
require "net/http"
class ProxyApp
  def call(env)
    begin
      request = Rack::Request.new(env)
      headers = {}
      dir = ""
      env.each do |key, value|
        if key =~ /^http_(.*)/i
          headers[$1] = value
        end

        if key == "HTTP_HOST"
          dir = value.chomp(".dev")
        end

      end
      http = Net::HTTP.new("localhost", 8080)
      http.start do |http|
        response = http.send_request(request.request_method, '/' + dir + '/' + request.fullpath, request.body.read, headers)
        [response.code, response.to_hash, [response.body]]
      end
      rescue Errno::ECONNREFUSED
      [500, {}, ["Server is down, try $ sudo apachectl start"]]
    end
  end
end
run ProxyApp.new
```

I put this config.ru file in my Apache document root (/Library/WebServer/Documents). Then, whenever I start work on a project, I drop the folder in that directory.

The last part (a little tricky) is that I create a symlink in my .pow directory named after whatever folder I just dropped in the Apache document root, but the symlink points to /Library/WebServer/Documents. For example, if my project folder was called "newsite" I would create a symlink called "newsite" in .pow that points to /Library/WebServer/Documents. Then, when Pow receives requests for newsite.dev, it sees the symlink pointing to /Library/WebServer/Documents, finds the config.ru file there and that file acts as the proxy to Apache, which serves up the files in the folder I dropped into Apache's document root.

Trust me, this is way easier than managing Apache conf and /etc/hosts entries.
