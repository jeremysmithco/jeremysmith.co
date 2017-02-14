---
title: Managing Redirects in Middleman
date: 2017-02-14 18:55 UTC
tags: ruby, middleman
---

If you need to maintain redirects for old pages in a [Middleman](https://middlemanapp.com/) site, you can do so by adding something like this to your config file:

```
redirect "/my/old-page.html", to: "/my/new-page/"
```

If you've only got a few redirects, this isn't too bad. But if you have dozens or hundreds, all those redirect calls makes reading your config much more difficult. Instead, try this.

Create a data file for your redirects in `data/redirects.yml` with the original path and the desired redirect.

```yaml
 - original: training/old-registration
   redirect: /training/registration
 - original: training/old-course
   redirect: /training/course
 - original: software/project1
   redirect: https://github.com/company/project1
 - original: software/project2
   redirect: https://github.com/company/project2
 - original: training/additional
   redirect: /training
```

Then, in your `config.rb`, you can simply iterate over your redirects from the data file.

```
data.redirects.each do |redirect|
  redirect "#{redirect.original}/index.html", to: redirect.redirect
end
```

## Notes

The [Redirects documentation](https://middlemanapp.com/basics/redirects/) shows a leading slash on the original path. However, at the time of this writing, there seems to be [an issue with that leading slash](https://github.com/middleman/middleman/issues/2011) on the original path.

Also, I'm using [Directory Indexes](https://middlemanapp.com/advanced/pretty_urls), so my example config uses `"#{redirect.original}/index.html"`, because it's matching paths ending with `/index.html`.
