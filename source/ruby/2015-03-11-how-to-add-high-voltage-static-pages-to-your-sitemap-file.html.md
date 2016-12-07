---
title: How to add High Voltage static pages to your sitemap file
date: 2015-03-11 22:45 UTC
tags:
---

<a href="https://github.com/thoughtbot/high_voltage">High Voltage</a> is a fantastic gem for adding static pages to your Rails app. I’m using it extensively on a project that has a large number of static, style-heavy pages that don’t make sense to serve from the database.

The other day my client asked me to add a sitemap XML file to the app that Google could consume (this is something that you can set up under <a href="https://www.google.com/webmasters/tools/">Google Webmaster Tools</a> that is supposed to help with site indexing).

I checked out several approaches for building sitemaps in a Rails app and settled on using the <a href="https://github.com/kjvarga/sitemap_generator">SitemapGenerator</a> gem. This gem allows you to easily create paths to ActiveRecord resources. For example, if you want your sitemap to include all the FAQ pages you have, you could do something like this in the config file:

```
Faq.published.find_each do |faq|
  add faq_path(faq), lastmod: faq.updated_at
end
```

But there’s no built-in way to include all your High Voltage static pages, as High Voltage doesn’t currently offer a way to get a list of all your pages.

So, I wrote a class you can put in your lib folder to do just that:

```
require 'find'

class HighVoltagePages
  attr_reader :pages

  def initialize(ministry)
    @pages = get_pages
  end

  private

  def get_pages
    pages = []

    Find.find(content_path) do |f|
      pages.push url_path(f) if !directory?(f) && html?(f) && !partial?(f)
    end

    pages
  end

  def url_path(f)
    f.gsub(content_path, '').gsub(file_pattern, '')
  end

  def directory?(f)
    FileTest.directory?(f)
  end

  def partial?(f)
    File.basename(f).first == "_"
  end

  def html?(f)
    f.match(file_pattern)
  end

  def content_path
    Rails.root.join('app', 'views', HighVoltage.content_path).to_s
  end

  def file_pattern
    /\.(html)(\.[a-z]+)?$/
  end

end
```

Now all you have to do in your sitemap config file is iterate over those pages:

```
HighVoltagePages.new.pages.each do |page|
  add page
end
```
